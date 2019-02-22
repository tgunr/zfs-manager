//
// Created by Dave Carlton on 2019-02-22.
// Copyright (c) 2019 Dave Carlton. All rights reserved.
//

import Foundation

struct Pool {
    var name = ""
    var size = ""
    var alloc = ""
    var free = ""
    var ckpoint = ""
    var expandsz = ""
    var frag = ""
    var cap = ""
    var dedup = ""
    var health = ""
    var altroot = ""

    // TODO: find a more elegant way to map these
    func stringToPool (poolString: String) -> Pool {
        var newPool = Pool()
        var parts = poolString.components(separatedBy: "\t")
        newPool.name = parts[0]
        newPool.size = parts[1]
        newPool.alloc = parts[2]
        newPool.free = parts[3]
        newPool.ckpoint = parts[4]
        newPool.expandsz = parts[5]
        newPool.frag = parts[6]
        newPool.cap = parts[7]
        newPool.dedup = parts[8]
        newPool.health = parts[9]
        newPool.altroot = parts[10]
        return newPool
    }

}