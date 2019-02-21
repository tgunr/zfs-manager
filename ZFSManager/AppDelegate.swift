//
//  AppDelegate.swift
//  ZFSManager
//
//  Created by Dave Carlton on 1/23/19.
//  Copyright © 2019 Dave Carlton. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var connection: Connection?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    class func applicationSupport() -> String {
        var appSupportDir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first?.absoluteString
//        if error != nil {
//            print("Error retrieving data directory path: \(error?.localizedDescription ?? "")")
//        }
        if appSupportDir != nil {
            let appBundleID = Bundle.main.bundleIdentifier
            appSupportDir = appSupportDir?.appending(appBundleID ?? "")
        }

        return appSupportDir!
    }
    
    class func dataSupport() -> String {
        let dataPath = applicationSupport().appending(SPDataSupportFolder)
        return dataPath
    }
}

