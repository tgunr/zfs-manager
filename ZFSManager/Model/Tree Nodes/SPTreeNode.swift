//
//  SPTreeNode.swift
//  sequel-pro
//
//  Created by Stuart Connolly (stuconnolly.com) on November 23, 2010.
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

/**
 * @class SPTreeNode SPTreeNode.h
 *
 * @author Stuart Connolly http://stuconnolly.com/
 *
 * NSTreeNode subclass which adds some convenience methods.
 */
// Constants
private var SPTreeNodeIsGroupKey = "SPTreeNodeIsGroup"

class SPTreeNode: NSTreeNode, NSCoding {
    private(set) var childNodes: [SPTreeNode]?
    /**
     * @property isGroup Indicates whether or not the node is a group.
     */
    var isGroup = false

    func removeObject(fromChildren object: Any?) {
        for node: SPTreeNode? in children ?? [] {
            if node == (object as? SPTreeNode) {
                mutableChildren = mutableChildren.filter({ ($0) as AnyObject !== (object) as AnyObject })
                return
            }

            if node?.isGroup != nil {
                node?.removeObject(fromChildren: object)
            }
        }
    }

    func descendants() -> [AnyHashable]? {
        var descendants: [AnyHashable] = []

        for node: SPTreeNode? in children ?? [] {
            if let node = node {
                descendants.append(node)
            }

            if node?.isGroup != nil {
                if let descendants = node?.descendants() {
                    descendants.append(contentsOf: descendants)
                }
            }
        }

        return descendants
    }

    func childLeafs() -> [AnyHashable]? {
        var childLeafs: [AnyHashable] = []

        for node: SPTreeNode? in children ?? [] {
            if node?.isGroup == nil {
                if let node = node {
                    childLeafs.append(node)
                }
            }
        }

        return childLeafs
    }

    func allChildLeafs() -> [AnyHashable]? {
        var childLeafs: [AnyHashable] = []

        for node: SPTreeNode? in children ?? [] {
            if node?.isGroup == nil {
                if let node = node {
                    childLeafs.append(node)
                }
            } else {
                if let all = node?.allChildLeafs() {
                    childLeafs.append(contentsOf: all)
                }
            }
        }

        return childLeafs
    }

    func groupChildren() -> [AnyHashable]? {
        var groupChildren: [AnyHashable] = []

        for node: SPTreeNode? in children ?? [] {
            if node?.isGroup != nil {
                if let node = node {
                    groupChildren.append(node)
                }
            }
        }

        return groupChildren
    }

    func parent(fromArray array: [Any]?) -> SPTreeNode? {
        var result: SPTreeNode? = nil

        for node: SPTreeNode? in array as? [SPTreeNode?] ?? [] {
            if node == self {
                break
            }

            if (node?.children as NSArray?)?.indexOfObjectIdentical(to: self) != NSNotFound {
                result = node
                break
            }

            if node?.isGroup != nil {
                let innerNode: SPTreeNode? = parent(fromArray: node?.children)

                if innerNode != nil {
                    result = innerNode
                    break
                }
            }
        }

        return result
    }

    func isDescendantOfOrOne(ofNodes nodes: [Any]?) -> Bool {
        for node: SPTreeNode? in nodes as? [SPTreeNode?] ?? [] {
            if node == self {
                return true
            }

            // Check all the sub-nodes
            if node?.isGroup != nil {
                if isDescendantOfOrOne(ofNodes: node?.children) {
                    return true
                }
            }
        }

        return false
    }

    func isDescendantOfNodes(_ nodes: [Any]?) -> Bool {
        for node: SPTreeNode? in nodes as? [SPTreeNode?] ?? [] {
            if node == self {
                continue
            }

            // Check all the sub-nodes
            if node?.isGroup != nil {
                if isDescendantOfOrOne(ofNodes: node?.children) {
                    return true
                }
            }
        }

        return false
    }

    func dictionaryRepresentation() -> [AnyHashable : ObjectType] {
        var dictionary: [AnyHashable : Any]? = nil

        let object = representedObject

        if (object is SPFavoriteNode) {

            dictionary = object?.nodeFavorite()
        } else if (object is SPGroupNode) {

            var children: [AnyHashable] = []

            for node: SPTreeNode? in self.children ?? [] {
                let representation = node?.dictionaryRepresentation()

                if representation != nil {
                    if let representation = representation {
                        children.append(representation)
                    }
                }
            }

            dictionary = [AnyHashable : Any]()

            let name = (!parent!) != nil ? NSLocalizedString("Favorites", comment: "favorites label") : object?.nodeName

            dictionary?[SPFavoritesGroupNameKey] = name != nil ? name : ""
            dictionary?[SPFavoritesGroupIsExpandedKey] = NSNumber(value: object?.nodeIsExpanded() != nil)
            dictionary?[SPFavoriteChildrenKey] = children
        }

        return dictionary as? [AnyHashable : ObjectType] ?? [:]
    }

// MARK: -
// MARK: Initialisation
    convenience init(representedObject object: Any?) {
        self.init(representedObject: object)
    }

    override init(representedObject object: Any?) {
        //if super.init(representedObject: object)
        self.isGroup = object is SPGroupNode
    }

// MARK: -
// MARK: Public API

    /**
     * Recursive method which searches children and children of all sub-nodes
     * to remove the supplied object.
     *
     * @param object The object to remove
     */
    /**
     * Generates an array of all descendants.
     *
     * @return The array of decendant nodes.
     */
    /**
     * Generates an array of this node's child leafs nodes.
     *
     * @return The array of child nodes.
     */
    /**
     * Generates an array of all leafs in children and children of all sub-nodes (effectively all leaf nodes below
     * this node.
     *
     * @return The array of child nodes.
     */
    /**
     * Returns only the children that are group nodes.
     *
     * @return The array of child group nodes.
     */
    /**
     * Finds the receiver's parent from the supplied array of nodes.
     *
     * @param array The array of nodes
     *
     * @return The parent of this instance of nil if not found
     */
    /**
     * Returns YES if self is contained anywhere inside the children or children of
     * sub-nodes of the nodes contained inside the supplied array or is itself a 
     * member of the array.
     *
     * @param nodes The array of nodes to search
     * 
     * @return A BOOL indicating whether or not it's a descendent or array member
     */
    /**
     * Returns YES if self is contained anywhere inside the children or children of
     * sub-nodes of the nodes contained inside the supplied array, but NOT the given
     * array itself. 
     * This means, if self is a member of nodes but not a child of any
     * other node in nodes it will still return NO.
     *
     * @param nodes The array of nodes to search
     *
     * @return A BOOL indicating whether or not it's a descendent
     */
    /**
     * Constructs a dictionary representation of the favorite.
     *
     * @return The dictionary representation.
     */
// MARK: -
// MARK: Coding protocol methods
    required init?(coder coder: NSCoder) {
        #if false
        if !super.init() {
            return nil
        }
        #endif

        self.isGroup = (coder.decodeObject(forKey: SPTreeNodeIsGroupKey) as? NSNumber)?.boolValue ?? false
    }

    func encode(with coder: NSCoder) {
        coder.encode(NSNumber(value: isGroup), forKey: SPTreeNodeIsGroupKey)
    }

// MARK: -
// MARK: Other
    override class func description() -> String {
        var description = ""

        description += representedObject?.description() ?? ""
        description += "\n"

        let nodes = children

        for i in 0..<(nodes?.count ?? 0) {
            let node: SPTreeNode? = nodes?[i]

            description += (node?.isGroup) != nil ? node?.description : node?.representedObject?.description() ?? ""

            if i < ((nodes?.count ?? 0) - 1) {
                description += "\n"
            }
        }

        return description
    }
}