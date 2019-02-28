//
// Created by Dave Carlton on 2019-02-22.
// Copyright (c) 2019 Dave Carlton. All rights reserved.
//

import Foundation
struct ZFSPoolData {
    var name: String?
    var value: String?
    
    init(header: String, data: String) {
        name = header
        value = data
    }
}
struct ZFSPoolProperty {
    var name: String?
    var value: String?

    init(header: String, value: String) {
        self.name = header
        self.value = value
    }
}

struct ZFSPoolProperties {
    var array: [ZFSPoolProperty]?
}
struct ZFSPool {
    var name: String?
    // Need arrays for indexed data use in viewControllers
    var data = [ZFSPoolData]()
    var properties = [[ZFSPoolProperty]]()
    
    mutating func poolData(aPool: [String:String], headingArray: [String]) {
        name = aPool["NAME"]
        for theHeader in headingArray {
            let itsValue = aPool[theHeader]
            let zpoolData = ZFSPoolData(header: theHeader, data: itsValue!)
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
                let zpoolData = ZFSPoolProperty(header: theHeading, value: itsValue!)
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

struct ZFSPools {
    var zpoolsHeadings: [String]?
    var pools: [ZFSPool]? = []
    
    init() {
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
                var aZFSPool = ZFSPool(aPool: aPool, headingArray: headingArray)
                pools?.append(aZFSPool)
            }
        }
    }
}

