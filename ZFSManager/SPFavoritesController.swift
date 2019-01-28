//
//  SPFavoritesController.swift
//  sequel-pro
//
//  Created by Stuart Connolly (stuconnolly.com) on November 10, 2010.
//  Copyright (c) 2010 Stuart Connolly. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//
//  More info at <https://github.com/sequelpro/sequelpro>

import Foundation

private var sharedFavoritesController: SPFavoritesController? = nil

/**
 * @class SPFavoritesController SPFavoritesController.h
 *
 * @author Stuart Connolly http://stuconnolly.com/
 *
 * Connection favorites controller that provides a single point of access for managing the user's connection
 * favorites in memory and on disk.
 */
class SPFavoritesController: SPSingleton {
    var writeLock: pthread_mutex_t?
    var favoritesLock: pthread_mutex_t?

    /**
     * @property favoritesTree The current favorites tree
     */
    private(set) var favoritesTree: SPTreeNode?
    /**
     * @property favoritesData Favorites data dictionary
     */
    private(set) var favoritesData: [AnyHashable : Any] = [:]

    class func shared() -> SPFavoritesController? {
        let lockQueue = DispatchQueue(label: "self")
        lockQueue.sync {
            if sharedFavoritesController == nil {
                sharedFavoritesController = SPFavoritesController()
            }
        }

        return sharedFavoritesController
    }

    func saveFavorites() {
        pthread_mutex_lock(&favoritesLock!)
        Thread.detachNewThreadSelector(#selector(SPFavoritesController._saveFavoritesData(_:)), toTarget: self, with: favoritesTree?.children?[0].representedObject)
        
        pthread_mutex_unlock(&favoritesLock!)
    }

    func saveFavoritesSynchronously() {
        _saveFavoritesData(favoritesTree?.children?[0].representedObject as? [AnyHashable : Any])
    }

    func reloadFavorites(withSave save: Bool) {
        if save {
            saveFavorites()
        }

        //if favoritesData
        _loadFavorites()
        _constructFavoritesTree()
    }

    func addGroupNode(withName name: String?, asChildOf parent: SPTreeNode?) -> SPTreeNode? {
        let node = SPTreeNode(representedObject: SPGroupNode(name: name))

        node.isGroup = true

        _add(node, asChildOf: parent)

        saveFavorites()
        NotificationCenter.default.post(name: NSNotification.Name(SPConnectionFavoritesChangedNotification), object: self)

        return node
    }

    func addFavoriteNode(withData data: [AnyHashable : Any]?, asChildOf parent: SPTreeNode?) -> SPTreeNode? {
        let node: SPTreeNode? = _addFavoriteNode(withData: data, asChildOf: parent)

        saveFavorites()
        NotificationCenter.default.post(name: NSNotification.Name(SPConnectionFavoritesChangedNotification), object: self)

        return node
    }

    func removeFavoriteNode(_ node: SPTreeNode?) {
        favoritesTree?.removeObject(fromChildren: node)

        // Save data to disk
        saveFavorites()

        NotificationCenter.default.post(name: NSNotification.Name(SPConnectionFavoritesChangedNotification), object: self)
    }

    private func _loadFavorites() {
        pthread_mutex_lock(&favoritesLock!)

        var error: Error? = nil
        let fileManager = FileManager.default

        //if favoritesData
        SPClear(addr: favoritesData)
        let dataPath = AppDelegate.dataSupport()

        let favoritesFile = URL(fileURLWithPath: dataPath).appendingPathComponent(SPFavoritesDataFile).absoluteString

        // If the favorites data file already exists use it, otherwise create an empty one
        if fileManager.fileExists(atPath: favoritesFile) {
            favoritesData = NSDictionary(contentsOfFile: favoritesFile) as! [AnyHashable : Any]
        } else {
            let newFavorites = [SPFavoritesRootKey : [
                SPFavoritesGroupNameKey : NSLocalizedString("Favorites", comment: "favorites label"),
                SPFavoriteChildrenKey : []
            ]]

            error = nil
            
            let plistData = try? PropertyListSerialization.data(fromPropertyList:newFavorites, format: .xml, options: 0) as NSData
            if error != nil {
                if let error = error {
                    print("Error converting default favorites data to plist format: \(error)")
                }
            } else {
                try? plistData?.write(toFile: favoritesFile, options: .atomicWrite)
                if error != nil {
                    if let error = error {
                        print("Error writing default favorites data: \(error)")
                    }
                }
            }

            favoritesData = newFavorites
        }
    }

    private func _constructFavoritesTree() {
        pthread_mutex_lock(&favoritesLock!)

        #if false
        if !favoritesData {
            pthread_mutex_unlock(&favoritesLock)
            return
        }
        #endif

        let root = favoritesData[SPFavoritesRootKey] as? [AnyHashable : Any]

        let rootGroupNode = SPGroupNode()
        let favoritesGroupNode = SPGroupNode(name: (root?[SPFavoritesGroupNameKey] as! String).uppercased() ?? "")

        favoritesGroupNode.nodeIsExpanded = (root?[SPFavoritesGroupIsExpandedKey] as? NSNumber)?.boolValue ?? false

        let rootNode = SPTreeNode(representedObject: rootGroupNode)
        let favoritesNode = SPTreeNode(representedObject: favoritesGroupNode)

        rootNode.isGroup = true
        favoritesNode.isGroup = true

        for favorite: [AnyHashable : Any]? in root?[SPFavoriteChildrenKey] as! [[AnyHashable : Any]?] {
            let node: SPTreeNode? = _constructBranch(forNodeData: favorite)

            if let node = node {
                favoritesNode.mutableChildren.add(node)
            }
        }

        rootNode.mutableChildren.add(favoritesNode)

        favoritesTree = rootNode

        pthread_mutex_unlock(&favoritesLock!)
    }

    @objc private func _saveFavoritesData(_ data: [AnyHashable : Any]?) {
        autoreleasepool {
            pthread_mutex_lock(&writeLock!)

            if favoritesTree == nil {
            }

            var error: Error? = nil

            // Before starting the file actions, attempt to create a dictionary
            // from the current favourites tree and convert it to a dictionary representation
            // to create the plist data.  This is done before file changes as it can sometimes
            // be terminated during shutdown.
            var dictionary: [String : [AnyHashable : Any]?]? = nil
            if let data = data {
                dictionary = [
                SPFavoritesRootKey: data
            ]
            }

            var plistData: Data? = nil
            if let dictionary = dictionary {
                plistData = try? PropertyListSerialization.data(fromPropertyList: dictionary, format: .xml, options:0)
            }
            if error != nil {
                if let error = error {
                    print("Error converting favorites data to plist format: \(error)")
                }
            }

            let fileManager = FileManager.default

            let dataPath = AppDelegate.dataSupport()

            let favoritesFileURL: URL = URL(fileURLWithPath: dataPath).appendingPathComponent(SPFavoritesDataFile)
            let favoritesFile: String = favoritesFileURL.absoluteString

            let uuid = UUID().uuidString
            let favoritesBackupFileURL: URL = URL(fileURLWithPath: dataPath).appendingPathComponent(uuid)
            let favoritesBackupFile: String = favoritesBackupFileURL.absoluteString

            // If the favorites data file already exists, attempt to move it to keep as a backup
            if fileManager.fileExists(atPath: favoritesFile) {
                try? fileManager.moveItem(atPath: favoritesFile, toPath: favoritesBackupFile)
            }

            if error != nil {
                print("Unable to backup (move) existing favorites data file during save. Deleting instead: \(error?.localizedDescription ?? "")")

                error = nil

                // We can't move it so try and delete it
                if (try? fileManager.removeItem(atPath: favoritesFile)) == nil && error != nil {
                    print("Unable to delete existing favorites data file during save. Something is wrong, permissions perhaps: \(error?.localizedDescription ?? "")")
                }
            }

            // Write the converted data to the favourites file
            try? plistData?.write(to: favoritesFileURL)
            if error != nil {
                print("Error writing favorites data. Restoring backup if available: \(error?.localizedDescription ?? "")")

                // Restore the original data file
                error = nil

                try? fileManager.moveItem(atPath: favoritesBackupFile, toPath: favoritesFile)

                if error != nil {
                    print("Could not restore backup; favorites.plist left renamed as \(favoritesBackupFile) due to error (\(error?.localizedDescription ?? ""))")
                }
            } else {
                // Remove the original backup
                try? fileManager.removeItem(atPath: favoritesBackupFile)
            }
        }
    }

    private func _add(_ node: SPTreeNode?, asChildOf parent: SPTreeNode?) {
        if parent != nil {
            parent?.mutableChildren.add(node as Any)
        } else {
            (favoritesTree?.mutableChildren[0] as! SPTreeNode).mutableChildren.add(node!)
        }
    }

    private func _constructBranch(forNodeData nodeData: [AnyHashable : Any]?) -> SPTreeNode? {
        var node: Any? = nil
        var treeNode: SPTreeNode? = nil

        if nodeData?[SPFavoritesGroupNameKey] != nil && nodeData?[SPFavoriteChildrenKey] != nil {

            node = SPGroupNode(name: nodeData?[SPFavoritesGroupNameKey] as? String ?? "")

            (node as! SPGroupNode?)!.nodeIsExpanded = (nodeData?[SPFavoritesGroupIsExpandedKey] as? NSNumber)?.boolValue ?? false

            treeNode = SPTreeNode(representedObject: node)

            treeNode?.isGroup = true

            for favorite: [AnyHashable : Any]? in nodeData?[SPFavoriteChildrenKey] as! [[AnyHashable : Any]?] {
                let innerNode: SPTreeNode? = _constructBranch(forNodeData: favorite)

                if let innerNode = innerNode {
                    treeNode?.mutableChildren.add(innerNode)
                }
            }
        } else {
            node = SPFavoriteNode(dictionary: nodeData)
            treeNode = SPTreeNode(representedObject: node)
        }

        return treeNode
    }

    private func _addFavoriteNode(withData data: [AnyHashable : Any]?, asChildOf parent: SPTreeNode?) -> SPTreeNode? {
        var object: Any?
        var childs: [Any]? = nil
        //if it has "Children" it must be a group node, otherwise assume favorite node
        if data?[SPFavoriteChildrenKey] != nil {
            object = SPGroupNode(dictionary: data ?? [:])
            childs = data?[SPFavoriteChildrenKey] as? [Any]
        } else {
            object = SPFavoriteNode(dictionary: data)
        }

        let node = SPTreeNode(representedObject: object)

        _add(node, asChildOf: parent)

        //also add the children
        if childs != nil {
            for childData: [AnyHashable : Any]? in childs as? [[AnyHashable : Any]?] ?? [] {
                _addFavoriteNode(withData: childData, asChildOf: node)
            }
        }

        return node
    }

// MARK: -
// MARK: Initialisation
    class func alloc(with zone: NSZone?) -> Any? {
        let lockQueue = DispatchQueue(label: "self")
        lockQueue.sync {
            return self.shared()?.retain()
        }

        return nil
    }

    override init() {
        super.init()
        favoritesTree = nil
        favoritesData = [:]

        pthread_mutex_init(&writeLock!, nil)
        pthread_mutex_init(&favoritesLock!, nil)

        _loadFavorites()
        _constructFavoritesTree()
    }

// MARK: -

    /**
     * Returns the shared favorites controller.
     *
     * @return The shared controller instance.
     */
// MARK: -
// MARK: Favorites data handling

    /**
     * Saves the current favorites dictionary in memory to disk. Note that the current favorites data file is moved
     * rather than overwritten in the event that we can't write the new file, the original can simply be restored.
     * This method also does a lot of error checking to ensure we don't lose the user's favorites data.
     * Saves the data in the background so any UI tasks can stay responsive.
     */
    /**
     * Save the current favorites dictionary in memory to disk, in the foreground, in a blocking manner.
     */
    /**
     * Reloads the favorites data from disk with the option to save before doing so.
     *
     * @param save Indicates whether the current favorites data in memory should be saved to disk before being
     *             reloaded. Specifying NO effectively discards any changes since the last save operation.
     */
// MARK: -
// MARK: Favorites interaction

    /**
     * Adds a new group node with the supplied name to the children of the supplied parent node.
     *
     * @param name   The name of the new group
     * @param parent 
     *
     * @return The node instance that was created and added
     */
    /**
     * Adds a new favorite node with the supplied data to the children of the supplied parent node.
     *
     * @param data   The data for the new favorite
     * @param 
     *
     * @return The node instance that was created and added
     */
    /**
     * Inner recursive variant of the method above
     */
    /**
     * Removes the supplied favorite node by asking the root node to remove it from it's children (i.e. the
     * entire tree is searched.
     *
     * @param The node to be removed
     */
// MARK: -
// MARK: Private API

    /**
     * Attempts to load the users connection favorites from ~/Library/Application Support/Sequel Pro/Data/Favorites.plist
     * If the 'Data' directory doesn't already exist it will be created, as well as an empty favorites plist.
     */
    /**
     * Constructs the favorites tree by initialising an instance of SPFavoriteNode for every favorite and group.
     */
    /**
     * Constructs the tree branch for the supplied favorites data. Note that depending on the contents of the 
     * branch (i.e. does it contain any groups and their depth) this method will recursively call itself.
     *
     * @param nodeData The favorites data dictionary
     *
     * @return The root node of the branch
     */
    /**
     * Saves the supplied favorites data to disk on a background thread.
     *
     * @param data The raw plist data (serialized NSDictionary) to be saved 
     */
    /**
     * Adds the supplied node to the children of the supplied parent and saves the tree to disk.
     *
     * @param node    The node to be added
     * @param asChild 
     */
// MARK: -
    deinit {
        if favoritesTree != nil {
            SPClear(addr: favoritesTree)
        }
        //if favoritesData
        SPClear(addr: favoritesData)

        pthread_mutex_destroy(&writeLock!)
        pthread_mutex_destroy(&favoritesLock!)
    }
}
