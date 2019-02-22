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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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

