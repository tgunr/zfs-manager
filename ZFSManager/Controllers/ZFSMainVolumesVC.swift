//
//  ZFSMainVolumesVC.swift
//  ZFSManager
//
//  Created by Dave Carlton on 2/23/19.
//  Copyright © 2019 Dave Carlton. All rights reserved.
//

import Cocoa

class ZFSMainVolumesVC: ZFSMainVC {
    var pools: ZFSPools?
    
    @IBOutlet weak var volumesSourceList: NSOutlineView!
    @IBOutlet weak var poolsPUB: NSPopUpButton!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        pools = self.appDelegate.pools
    }
}

