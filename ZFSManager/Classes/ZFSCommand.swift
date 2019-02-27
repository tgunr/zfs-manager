//
//  ZFSCommand.swift
//  ZFSManager
//
//  Created by Dave Carlton on 2/23/19.
//  Copyright © 2019 Dave Carlton. All rights reserved.
//

import Foundation

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
        var result = [[String:String]]()
        if ( exitCode == 0) {
            for aLine in data {
                let thisLine = aLine.components(separatedBy: "\t")
                var theData: [String:String] = [String:String]()
                var colNum = 0
                for heading in using {
                    let dataValue = thisLine[colNum]
                    theData[heading] = dataValue
                    colNum += 1
                }
                result.append(theData)
            }
        }
        return result
    }
}
