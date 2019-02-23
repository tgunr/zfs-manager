//
// Created by Dave Carlton on 2019-02-22.
// Copyright (c) 2019 Dave Carlton. All rights reserved.
//

import Foundation

struct ZFSPool {
    var data = ["":""]
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
    func stringToPool (poolString: String) -> ZFSPool {
        var newPool = ZFSPool()
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

struct ZFSPools {
    var headers: [String]?
    var pools: [ZFSPool]? = []
    
    mutating func poolHeader() -> [String] {
        if headers == nil {
            var hParts = [""]
            var result = shell(cmd: zpoolCmd, args: ["list"])
            if (result.exitCode == 0) {
                let headerString = result.output[0].components(separatedBy: "\n")
                hParts = headerString[0].condensingWhitespace().components(separatedBy: .whitespaces)
            }
            headers = hParts
        }
        return headers!
    }
    
    init() {
        var pData = ["":""]
        let hParts = poolHeader()
        let result = shell(cmd: zpoolCmd, args: ["list", "-H"])
        if (result.exitCode == 0) {
            let poolStrings = result.output
            for poolString in poolStrings {
                let thisPool = poolString.components(separatedBy: "\t")
                var colNum = 0
                for col in hParts {
                    pData[col] = thisPool[colNum]
                    colNum += 1
                }
//                print("Data: \(pData)\n")
                var newPool = ZFSPool()
                newPool.data = pData
                pools?.append(newPool)
            }
        }
    }

}
