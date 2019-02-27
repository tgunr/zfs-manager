//
// Created by Dave Carlton on 2019-02-22.
// Copyright (c) 2019 Dave Carlton. All rights reserved.
//

import Foundation

struct ZFSPool {
    var name: String
    var data = ["":""]
    var properties = ["":""]
    
    init(pool: String, poolData: [String:String]) {
        data = poolData
        name = poolData["NAME"]!
        properties = poolProperties(pool)
    }
    
    mutating func poolProperties(_ pool: String) -> [String:String] {
        var zfs = ZFSCommand(zpoolCmd, with: ["get", "all", pool])
        zfs.execute()
        var headers = zfs.headings()
        zfs = ZFSCommand(zpoolCmd, with: ["get", "-H", "all", pool])
        return ["":""]
    }
}

struct ZFSPools {
    var headers: [String]?
    var pools: [ZFSPool]? = []
    
    mutating func poolHeader() -> [String] {
        if headers == nil {
            var hParts = [""]
            var zfs = ZFSCommand(zpoolCmd, with: ["list"])
            zfs.execute()
            if (zfs.exitCode == 0) {
                let headerString = zfs.data[0].components(separatedBy: "\n")
                hParts = headerString[0].condensingWhitespace().components(separatedBy: .whitespaces)
            }
            headers = hParts
        }
        return headers!
    }
    
    init() {
        let hParts = poolHeader()
        var zfs = ZFSCommand(zpoolCmd, with: ["list", "-H"])
        zfs.execute()
        if let pData = zfs.allLinesData(using: hParts) {
            for aPool in pData {
                let poolName = aPool["NAME"]
                let newPool = ZFSPool(pool: poolName!, poolData: aPool)
                pools?.append(newPool)
            }
        }
    }
}

