//
//  SPFavoriteNode.swift
//  sequel-pro
//
//  Created by Stuart Connolly (stuconnolly.com) on November 8, 2010.
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
 * @class SPFavoriteNode SPFavoriteNode.h
 *
 * @author Stuart Connolly http://stuconnolly.com/
 *
 * Tree node that represents a connection favorite.
 */
import Foundation

// Constants
private var SPFavoriteNodeKey = "SPFavoriteNode"

class SPFavoriteNode: NSObject, NSCopying, NSCoding {
    /**
     * @property nodeFavorite The actual favorite dictionary
     */
    var nodeFavorite: [AnyHashable : Any] = [:]

    convenience init(dictionary: [AnyHashable : Any]) {
        //if self.init()
        self.init()
        self.nodeFavorite = dictionary
    }

    convenience init(dictionary: [AnyHashable : Any]?) {
            self.init(dictionary: dictionary)
    }

// MARK: -
// MARK: Initialisation
    override init() {
        //if super.init()
        self.nodeFavorite = [:]
    }

// MARK: -
// MARK: Copying protocol methods
    func copy(with zone: NSZone? = nil) -> Any {
        let node = SPFavoriteNode()
//        let anode = alloc(with: zone)() as? SPFavoriteNode

        if let copy = node.copy(with: zone) as? [AnyHashable : Any] {
            node.nodeFavorite = copy
        }

        return node
    }

// MARK: -
// MARK: Coding protocol methods
    required init?(coder coder: NSCoder) {
        #if false
        if !super.init() {
            return nil
        }
        #endif

        if let decode = coder.decodeObject(forKey: SPFavoriteNodeKey) as? [AnyHashable : Any] {
            self.nodeFavorite = decode
        }
    }

    func encode(with coder: NSCoder) {
        coder.encode(nodeFavorite, forKey: SPFavoriteNodeKey)
    }

// MARK: -
// MARK: Other
    override class func description() -> String {
        return super.description()
//        return String(format: "<%@: %p ('%@')>", className, self, nodeName() ?? "")
    }

    func nodeName() -> String? {
        return nodeFavorite[SPFavoriteNameKey] as? String
    }

// MARK: -
    deinit {
        //if nodeFavorite
        SPClear(addr: nodeFavorite)
    }
}
