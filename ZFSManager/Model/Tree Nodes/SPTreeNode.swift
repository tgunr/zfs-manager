//
//  SPTreeNode.swift
/**
 * @class SPTreeNode SPTreeNode.h
 *
 * @author Stuart Connolly http://stuconnolly.com/
 *
 * NSTreeNode subclass which adds some convenience methods.
 */

import AppKit

// Constants
private var SPTreeNodeIsGroupKey = "SPTreeNodeIsGroup"

class SPTreeNode: NSTreeNode, NSCoding {
    var nodes: [SPTreeNode]?
    /**
     * @property isGroup Indicates whether or not the node is a group.
     */
    var isGroup = false

    func removeObject(fromChildren object: Any?) {
        for node in children ?? [] {
            if node == (object as? SPTreeNode) {
                let thisNode = node as! SPTreeNode
                let thisNodeMutable = thisNode.mutableChildren.filter({ ($0) as AnyObject !== (object) as AnyObject })
                let nodeIndex = children?.firstIndex(of: thisNode)
                self.mutableChildren.replaceObject(at: nodeIndex!, with: thisNodeMutable)
                return
            }
            let thisNode = node as! SPTreeNode
            if thisNode.isGroup {
                thisNode.removeObject(fromChildren: object)
            }
        }
    }

    func descendants() -> [AnyHashable]? {
        var descendants: [AnyHashable] = []
        let theChildren: [AnyHashable?] = children ?? []
        
        for node in theChildren {
            if node != nil {
                descendants.append(node!)
            }
            
            if node is SPTreeNode {
                let thisNode = node as! SPTreeNode
                if thisNode.isGroup {
                    if let thisNodeDescendants = thisNode.descendants() {
                        descendants.append(contentsOf: thisNodeDescendants)
                    }
                }
            }
        }
        
        return descendants
    }

    func childLeafs() -> [AnyHashable]? {
        var childLeafs: [AnyHashable] = []
        
        for node in children ?? [] {
            let thisNode = node as! SPTreeNode
            if thisNode.isGroup {
                childLeafs.append(thisNode)
            }
        }
        
        return childLeafs
    }

    func allChildLeafs() -> [AnyHashable]? {
        var childLeafs: [AnyHashable] = []

        for node in children ?? [] {
            let thisNode = node as! SPTreeNode
            if thisNode.isGroup {
                    childLeafs.append(thisNode)
            } else {
                if let all = thisNode.allChildLeafs() {
                    childLeafs.append(contentsOf: all)
                }
            }
        }

        return childLeafs
    }

    func groupChildren() -> [AnyHashable]? {
        var groupChildren: [AnyHashable] = []
        
        for node in children ?? [] {
            let thisNode = node as! SPTreeNode
            if thisNode.isGroup {
                groupChildren.append(thisNode)
            }
        }
    
        return groupChildren
    }

    func parent(fromArray array: [SPTreeNode]?) -> SPTreeNode? {
        var result: SPTreeNode? = nil
        for node in array ?? [] {
            if node == self {
                break
            }

            if (node.children as NSArray?)?.indexOfObjectIdentical(to: self) != NSNotFound {
                result = node
                break
            }

            let thisNode = node
            if thisNode.isGroup {
                let innerNode: SPTreeNode? = parent(fromArray: thisNode.children as? [SPTreeNode])

                if innerNode != nil {
                    result = innerNode
                    break
                }
            }
        }

        return result
    }

    func isDescendantOfOrOne(ofNodes nodes: [SPTreeNode]?) -> Bool {
        for node: SPTreeNode? in nodes ?? [] {
            if node == self {
                return true
            }

            // Check all the sub-nodes
            if node?.isGroup != nil {
                if isDescendantOfOrOne(ofNodes: node?.children as? [SPTreeNode]) {
                    return true
                }
            }
        }

        return false
    }

    func isDescendantOfNodes(_ nodes: [SPTreeNode]?) -> Bool {
        for node: SPTreeNode? in nodes ?? [] {
            if node == self {
                continue
            }

            // Check all the sub-nodes
            if node?.isGroup != nil {
                if isDescendantOfOrOne(ofNodes: node?.children as? [SPTreeNode]) {
                    return true
                }
            }
        }

        return false
    }

    func dictionaryRepresentation() -> [AnyHashable : Any] {
        var dictionary: [AnyHashable : Any]? = nil

        let object = self.representedObject

        if (object is SPFavoriteNode) {
            let favoriteObject = object as! SPFavoriteNode
            dictionary = favoriteObject.nodeFavorite
        } else if (object is SPGroupNode) {

            var newChildren: [AnyHashable] = []
            let theChildren = self.children as? [SPTreeNode] ?? []
            for aNode: SPTreeNode? in theChildren  {
                let representation = aNode?.dictionaryRepresentation()
                if representation != nil {
                    newChildren.append(representation as! AnyHashable)
                }
            }

            let favoriteObject = object as? SPFavoriteNode
            dictionary = [AnyHashable : Any]()
            var aName: String?
            let myParent = self.parent
            if myParent != nil {
                aName = NSLocalizedString("Favorites", comment: "favorites label")
            } else {
                aName = favoriteObject?.nodeName()
            }

            dictionary?[SPFavoritesGroupNameKey] = aName != nil ? aName : ""
            if object is SPGroupNode {
                dictionary?[SPFavoritesGroupIsExpandedKey] = NSNumber(value: (object as! SPGroupNode).nodeIsExpanded)
            } else {
                dictionary?[SPFavoritesGroupIsExpandedKey] = NSNumber(value: 0)
            }
            dictionary?[SPFavoriteChildrenKey] = newChildren
        }

        return dictionary ?? [:]
    }

// MARK: -
// MARK: Initialisation
//    override init(representedObject object: Any?) {
//        self.init(representedObject: object)
//    }

    init(representedObject object: Any?, isGroup: Bool) {
        super.init()
        self.isGroup = isGroup
    }

    override init(representedObject object: Any?) {
        super.init(representedObject: object)
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
    required init?(coder: NSCoder) {
        super.init()
        self.isGroup = (coder.decodeObject(forKey: SPTreeNodeIsGroupKey) as? NSNumber)?.boolValue ?? false
    }

    func encode(with coder: NSCoder) {
        coder.encode(NSNumber(value: isGroup), forKey: SPTreeNodeIsGroupKey)
    }

// MARK: -
// MARK: Other
    func description() -> String {
        var description = ""
//        description += self.description()
        description += (representedObject as? SPTreeNode)?.description() ?? ""
        description += "\n"

        let theNodes = self.children as? [SPTreeNode] ?? []

        for i in 0..<(theNodes.count ) {
            let aNode: SPTreeNode? = theNodes[i]
            
            description += (aNode?.isGroup) != nil ? aNode?.description ?? "" : (aNode?.representedObject as! SPGroupNode).description

            if i < ((nodes?.count ?? 0) - 1) {
                description += "\n"
            }
        }

        return description
    }
}
