//
//  SPGroupNode.swift
//  sequel-pro
//
//  Created by Stuart Connolly (stuconnolly.com) on November 21, 2010.
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
 * @class SPGroupNode SPGroupNode.h
 *
 * @author Stuart Connolly http://stuconnolly.com/
 *
 * Tree node that represents a group.
 */
import Foundation

// Constants
private var SPGroupNodeNameKey = "SPGroupNodeName"
private var SPGroupNodeIsExpandedKey = "SPGroupNodeIsExpanded"

class SPGroupNode: NSObject, NSCopying, NSCoding, SPNamedNode {
    /**
     * @property nodeName The group node's name
     */
    var _nodeName = ""

    func nodeName() -> String? {
        return _nodeName
    }
    
    /**
     * @property nodeIsExpanded Indicates whether the group node is expanded
     */
    var nodeIsExpanded = false

    convenience init(name: String) {
        //if self.init()
        self.init()
        _nodeName = name
    }

    convenience init(dictionary dict: [AnyHashable : Any]) {
        //if (self.init(name: dict[SPFavoritesGroupNameKey] as? String ?? ""))
        self.init()
        self.nodeIsExpanded = (dict[SPFavoritesGroupIsExpandedKey] as? NSNumber)?.boolValue ?? false
    }

//    convenience init(dictionary dict: [AnyHashable : Any]?) {
//        if let dict = dict {
//            self.init(dictionary: dict)
//        }
//        return nil
//    }
//
// MARK: -
// MARK: Initialisation
    override init() {
        //if super.init()
        _nodeName = ""
        self.nodeIsExpanded = true
    }

// MARK: -
// MARK: Copying protocol methods
    func copy(with zone: NSZone? = nil) -> Any {
        let node = SPGroupNode()

        node._nodeName = self._nodeName
        node.nodeIsExpanded = self.nodeIsExpanded

        return node as Any
    }

    
// MARK: -
// MARK: Coding protocol methods
    required init?(coder: NSCoder) {
        #if false
        if !super.init() {
            return nil
        }
        #endif

        _nodeName = coder.decodeObject(forKey: SPGroupNodeNameKey) as? String ?? ""
        self.nodeIsExpanded = (coder.decodeObject(forKey: SPGroupNodeIsExpandedKey) as? NSNumber)?.boolValue ?? false
    }

    func encode(with coder: NSCoder) {
        coder.encode(_nodeName, forKey: SPGroupNodeNameKey)
        coder.encode(nodeIsExpanded, forKey: SPGroupNodeIsExpandedKey)
    }

// MARK: -
// MARK: Other
    override class func description() -> String {
        return String(format: "<%@: %p>", className(), self as! CVarArg)
    }

// MARK: -
    deinit {
        if _nodeName != "" {
            SPClear(addr: _nodeName)
        }
    }
    
}
