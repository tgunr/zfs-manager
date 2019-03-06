//
// Created by Dave Carlton on 2019-03-01.
// Copyright (c) 2019 Dave Carlton. All rights reserved.
//

import Cocoa

class ZFSMainTVC: ZFSMainVC {
    var tabviewController: ZFSMainTVC?
    var selectedView: ZFSMainTVC?

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

    // TODO: Fix this
//    override func tabView(_ tabView: NSTabView, didSelect tabViewItem: NSTabViewItem?) {
//        tabviewController = (tabViewItem?.viewController as! ZFSMainTVC)
//    }

}
