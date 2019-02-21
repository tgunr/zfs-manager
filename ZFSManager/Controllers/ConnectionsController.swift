//
//  ConnectionsController.swift
//  ZFSManager
//
//  Created by Dave Carlton on 2/21/19.
//  Copyright © 2019 Dave Carlton. All rights reserved.
//

import Cocoa

class ConnectionsController: NSViewController, NSTableViewDelegate {
    private var appDelegate = NSApplication.shared.delegate as! AppDelegate

    @IBOutlet weak var connectionsTable: NSOutlineView!
    
    @IBAction func connectLocal(_ sender: Any) {
        let selectedConnection = Connection()
        appDelegate.connection = selectedConnection
    }
}
