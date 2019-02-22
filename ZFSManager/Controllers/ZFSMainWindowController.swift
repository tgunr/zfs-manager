//
//  ZFSMainWindowController.swift
//  ZFSManager
//
//  Created by Dave Carlton on 2/21/19.
//  Copyright © 2019 Dave Carlton. All rights reserved.
//

import Cocoa

class ZFSMainViewController: NSTabViewController {
    private var appDelegate = NSApplication.shared.delegate as! AppDelegate
    var tabviewController: ZFSMainTabViewController?
    var zfsCommand = ""
    
    @IBOutlet weak var mainTabView: NSTabView!
    @IBOutlet weak var volumesTabView: NSTabViewItem!
    @IBOutlet weak var snapshotsTabView: NSTabViewItem!
    @IBOutlet weak var poolsTabView: NSTabViewItem!

    override func viewDidLoad() {
        super.viewDidLoad()
//        let result = runCommand(cmd: "which zfs", args: "")
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    override func tabView(_ tabView: NSTabView, didSelect tabViewItem: NSTabViewItem?) {
        tabviewController = (tabViewItem?.viewController as! ZFSMainTabViewController)
    }
}

class ZFSMainTabViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {
    private var appDelegate = NSApplication.shared.delegate as! AppDelegate
    var selectedView: ZFSMainTabViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
}

class ZFSMainPoolViewController: ZFSMainTabViewController {
    @IBOutlet weak var poolsTable: NSOutlineView!
    var pools: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let result = shell(cmd: "/usr/local/bin/zpool", args: ["list", "-H"])
        if (result.exitCode == 0) {
            pools = result.output
        }
    }
}

class ZFSMainVolumesViewController: ZFSMainTabViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
}

class ZFSMainSnapshotsViewController: ZFSMainTabViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
}

