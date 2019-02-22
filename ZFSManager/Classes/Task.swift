//
//  Task.swift
//  ZFSManager
//
//  Created by Dave Carlton on 2/21/19.
//  Copyright © 2019 Dave Carlton. All rights reserved.
//

import Foundation

func runCommand(cmd : String, args : String...) -> (output: [String], error: [String], exitCode: Int32) {
    
    var output : [String] = []
    var error : [String] = []
    
    let task = Process()
    task.launchPath = cmd
    task.arguments = args
    
    let outpipe = Pipe()
    task.standardOutput = outpipe
    let errpipe = Pipe()
    task.standardError = errpipe
    
    task.launch()
    
    var outdata = outpipe.fileHandleForReading.readDataToEndOfFile()
    var unsafePtr = UnsafePointer<CChar>(&outdata)
    var string = String(cString: unsafePtr, encoding: .utf8)
    string = string?.trimmingCharacters(in: CharacterSet.newlines)
    output = (string?.components(separatedBy: "\n"))!
    
    var errdata = errpipe.fileHandleForReading.readDataToEndOfFile()
    unsafePtr = UnsafePointer<CChar>(&errdata)
    string = string?.trimmingCharacters(in: CharacterSet.newlines)
    error = (string?.components(separatedBy: "\n"))!
    
    task.waitUntilExit()
    let status = task.terminationStatus
    
    return (output, error, status)
}
