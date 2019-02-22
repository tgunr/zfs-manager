//
//  Task.swift
//  ZFSManager
//
//  Created by Dave Carlton on 2/21/19.
//  Copyright © 2019 Dave Carlton. All rights reserved.
//

import Foundation

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

    var outdata = outpipe.fileHandleForReading.readDataToEndOfFile()
    var string = String(data: outdata, encoding: .utf8)
//    var unsafePtr = UnsafePointer<CChar>(&outdata)
//    var string = String(cString: unsafePtr, encoding: .utf8)
    string = string?.trimmingCharacters(in: CharacterSet.newlines)
    output = (string?.components(separatedBy: "\n"))!
    
    var errdata = errpipe.fileHandleForReading.readDataToEndOfFile()
//    unsafePtr = UnsafePointer<CChar>(&errdata)
    string = String(data: errdata, encoding: .utf8)
    string = string?.trimmingCharacters(in: CharacterSet.newlines)
    error = (string?.components(separatedBy: "\n"))!
    
    let status = task.terminationStatus
    
    return (output, error, status)
}
