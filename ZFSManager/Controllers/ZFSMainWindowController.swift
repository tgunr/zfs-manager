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

class ZFSMainTabViewController: NSViewController {
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

