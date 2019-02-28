//: A Cocoa based Playground to present user interface

import AppKit
import PlaygroundSupport

let nibFile = NSNib.Name("MyView")
var topLevelObjects : NSArray?

Bundle.main.loadNibNamed(nibFile, owner:nil, topLevelObjects: &topLevelObjects)
let views = (topLevelObjects as! Array<Any>).filter { $0 is NSView }

// Present the view in Playground
PlaygroundPage.current.liveView = views[0] as! NSView

//extension String {
//    func condensingWhitespace() -> String {
//        return self.components(separatedBy: .whitespacesAndNewlines)
//            .filter { !$0.isEmpty }
//            .joined(separator: " ")
//    }
//}
//
func shell(cmd : String, args : [String]) -> (output: [String], error: [String], exitCode: Int32) {
    
    var output : [String] = []
    var error : [String] = []
    
    let task = Process()
    task.launchPath = cmd
    task.arguments = args
    task.currentDirectoryPath = "/Users/davec"
    let outpipe = Pipe()
    task.standardOutput = outpipe
    let errpipe = Pipe()
    task.standardError = errpipe
    
    task.launch()
    task.waitUntilExit()
    
    let outdata = outpipe.fileHandleForReading.readDataToEndOfFile()
    var string = String(data: outdata, encoding: .utf8)
    //    var unsafePtr = UnsafePointer<CChar>(&outdata)
    //    var string = String(cString: unsafePtr, encoding: .utf8)
    string = string?.trimmingCharacters(in: CharacterSet.newlines)
    output = (string?.components(separatedBy: "\n"))!
    
    let errdata = errpipe.fileHandleForReading.readDataToEndOfFile()
    //    unsafePtr = UnsafePointer<CChar>(&errdata)
    string = String(data: errdata, encoding: .utf8)
    string = string?.trimmingCharacters(in: CharacterSet.newlines)
    error = (string?.components(separatedBy: "\n"))!
    
    let status = task.terminationStatus
    
    return (output, error, status)
}

struct ZFSCommand {
    var command: String
    var args: [String]
    var data: [String]
    var error: [String]
    var exitCode: Int32
    
    init(_ command: String, with: [String]) {
        self.command = command
        self.args = with
        self.data = [""]
        self.error = [""]
        self.exitCode = -1
    }
    
    mutating func execute() {
        print("command: \(command) args: \(args)")
        let result = shell(cmd: command, args: args)
        data = result.output
        error = result.error
        exitCode = result.exitCode
        return
    }
    
    func headings() -> [String]? {
        var hParts = [""]
        if exitCode == 0 {
            let headerString = data[0].components(separatedBy: "\n")
            hParts = headerString[0].condensingWhitespace().components(separatedBy: .whitespaces)
        }
        return hParts
    }
    
    func lineData(_ line: Int, using: [String]) -> [String:String]? {
        var pData: [String:String]?
        if (exitCode == 0) {
            let theLine = data[line]
            let thisLine = theLine.components(separatedBy: "\t")
            var colNum = 0
            for heading in using {
                pData?[heading] = thisLine[colNum]
                colNum += 1
            }
        }
        return pData
    }
    
    func allLinesData(using: [String]) -> [[String:String]]? {
        var result: [[String:String]]? = [[String:String]]()
        if ( exitCode == 0) {
            for aLine in data {
                let thisLine = aLine.components(separatedBy: "\t")
//                print("thisLine: \(thisLine)")
                var theData: [String:String]? = [String:String]()
                var colNum = 0
                for heading in using {
                    let dataValue = thisLine[colNum]
                    theData?[heading] = dataValue
                    colNum += 1
//                    print("theData: \(String(describing: theData?[heading]))")
                }
                result?.append(theData!)
            }
        }
        return result
    }
}

let zpoolCmd = "/usr/local/bin/zpool"
let zfsCmd = "/usr/local/bin/zfs"
let poolName = "tank"

// Pool
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
    var source: String?
}

struct ZFSPool {
    var name: String?
    // Need arrays for indexed data use in viewControllers
    var data = [ZFSPoolData]()
    var properties = [ZFSPoolProperty]()
    
//    init(_ someData: [ZFSPoolData]) {
//        data = someData
//    }
}

// Pools
var zpoolsHeadings: [String]?
var zpoolsData: [[String:String]]?

// Get the list of the pools extracting the headings
var zfsHeaders = ZFSCommand(zpoolCmd, with: ["list"])
zfsHeaders.execute()
zpoolsHeadings = zfsHeaders.headings()

// Get a list of the pools with their data
var zfsData = ZFSCommand(zpoolCmd, with: ["list", "-H"])
zfsData.execute()
zpoolsData = zfsData.allLinesData(using: zpoolsHeadings ?? [])

var thePools: [ZFSPool]?

var i = 0
if let poolsArray = zpoolsData {
    for aPool in poolsArray {
        if let poolArray = aPool {
            if let headingArray = zpoolsHeadings {
                var aZFSPool = ZFSPool()
                for theHeader in headingArray {
                    let itsValue = thePool[theHeader]
                    let zpoolData = ZFSPoolData(header: theHeader, data: itsValue!)
                    aZFSPool.data.append(zpoolData)
                }
                thePools?.append(aZFSPool)
            }
        }
    }
}
print(thePools!)


var zpoolHeaders: [String]?
var zpoolData = [[String:String]]()

//struct ZFSPoolold {
//    var name: String
//    // Need arrays for indexed data use in viewControllers
//    var data: [ZFSPoolData] = [ZFSPoolData]()
//    var properties:[ZFSPoolProperty] = [ZFSPoolProperty]()
//
//    // Create a pool from string data
//    init(name: String, data: [String], properties: [String]) {
//        data = ZFSPoolData(poolData)
//        name = poolData["NAME"]!
//        properties = poolProperties(pool)
//    }
//
//    mutating func poolProperties(_ pool: String) -> [String:String] {
//        var zfs = ZFSCommand(zpoolCmd, with: ["get", "all", pool])
//        zfs.execute()
//        var headers = zfs.headings()
//        zfs = ZFSCommand(zpoolCmd, with: ["get", "-H", "all", pool])
//        return ["":""]
//    }
//}

zfsHeaders = ZFSCommand(zpoolCmd, with: ["get", "all", poolName])
zfsHeaders.execute()
zpoolHeaders = zfsHeaders.headings()

zfsData = ZFSCommand(zpoolCmd, with: ["get", "-H", "all", poolName])
zfsData.execute()
zpoolData = zfsData.allLinesData(using: zpoolHeaders ?? [""])

//struct ZFSPools {
//    var headers: [String]?
//    var pools: [ZFSPool]? = []
//    var zpoolsHeaders: [String]?
//    var zpoolsData: [[String:String]]? = [[String:String]]()
//
//    mutating func poolHeaders() -> [String] {
//        if headers == nil {
//            var hParts = [""]
//            var zfs = ZFSCommand(zpoolCmd, with: ["list"])
//            zfs.execute()
//            if (zfs.exitCode == 0) {
//                zpoolsHeaders = zfs.headings()
//                let headerString = zfs.data[0].components(separatedBy: "\n")
//                hParts = headerString[0].condensingWhitespace().components(separatedBy: .whitespaces)
//            }
//            headers = hParts
//        }
//        return headers!
//    }
//
//    init() {
//        let headers = poolHeaders()
//        var zfs = ZFSCommand(zpoolCmd, with: ["list", "-H"])
//        zfs.execute()
//        if let dataLines = zfs.allLinesData(using: headers) {
//            // walk along string pulling data for each header
//            for thePoolData in dataLines {
//                let poolName = thePoolData["NAME"]
//                let newPool = ZFSPool(pool: poolName!, poolData: thePoolData)
//                pools?.append(newPool)
//            }
//        }
//    }
//}

