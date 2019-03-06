//
// Created by Dave Carlton on 2019-02-22.
// Copyright (c) 2019 Dave Carlton. All rights reserved.
//

import Foundation

class ZFS {
    var name: String?
    var value: String?

    init(name: String, value: String) {
        self.name = name
        self.value = value
    }
}

class ZFSPoolData: ZFS {
}

class ZFSPoolProperty: ZFS {
}

struct ZFSPoolProperties {
    var array: [ZFSPoolProperty]?
}

struct ZFSPool {
    var name: String?
    // Need arrays for indexed data use in viewControllers
    var data = [ZFSPoolData]()
    var properties = [[ZFSPoolProperty]]()
    var volumes = [ZFSVolumes]()

    mutating func poolData(aPool: [String:String], headingArray: [String]) {
        name = aPool["NAME"]
        for theHeader in headingArray {
            let itsValue = aPool[theHeader]
            let zpoolData = ZFSPoolData(name: theHeader, value: itsValue!)
            self.data.append(zpoolData)
        }
    }
    
    mutating func poolProperties(_ pool: String) {
        var zpoolsHeadings: [String]?
        var zpoolsData: [[String:String]]?
        
        // Get the list of the pools properties extracting the headings
        var zfsHeaders = ZFSCommand(zpoolCmd, with: ["get", "all", pool])
        zfsHeaders.execute()
        zpoolsHeadings = zfsHeaders.headings()
        
        // Get a list of the pool properties with their data
        var zfsData = ZFSCommand(zpoolCmd, with: ["get", "-H", "all", pool])
        zfsData.execute()
        zpoolsData = zfsData.allLinesData(using: zpoolsHeadings)

        for theData in zpoolsData! {
            var propertyList = [ZFSPoolProperty]()
            for theHeading in zpoolsHeadings! {
                let itsValue = theData[theHeading] // zpoolsData ![theHeader]
                let zpoolData = ZFSPoolProperty(name: theHeading, value: itsValue!)
                propertyList.append(zpoolData)
            }
            self.properties.append(propertyList)
        }
    }
    
    init(aPool: [String:String], headingArray: [String]) {
        name = aPool["NAME"]
        poolData(aPool: aPool, headingArray: headingArray)
        poolProperties(name!)
    }


}

class ZFSPools: NSObject {
    var zpoolsHeadings: [String]?
    var pools: [ZFSPool]? = []
    
    override init() {
        var zpoolsData: [[String:String]]?
        
        // Get the list of the pools extracting the headings
        var zfsHeaders = ZFSCommand(zpoolCmd, with: ["list"])
        zfsHeaders.execute()
        zpoolsHeadings = zfsHeaders.headings()
        
        // Get a list of the pools with their data
        var zfsData = ZFSCommand(zpoolCmd, with: ["list", "-H"])
        zfsData.execute()
        zpoolsData = zfsData.allLinesData(using: zpoolsHeadings)
        
        for aPool in zpoolsData! {
            if let headingArray = zpoolsHeadings {
                let aZFSPool = ZFSPool(aPool: aPool, headingArray: headingArray)
                pools?.append(aZFSPool)
            }
        }
    }
}

