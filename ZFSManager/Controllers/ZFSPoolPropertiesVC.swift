//
//  ZFSPoolPropertiesVC.swift
//  ZFSManager
//
//  Created by Dave Carlton on 2/23/19.
//  Copyright © 2019 Dave Carlton. All rights reserved.
//

import Cocoa

class ZFSPoolPropertiesVC: ZFSPoolVC {
    @IBOutlet weak var poolsTableHeaderView: NSTableHeaderView!
    @IBOutlet weak var poolsTableView: NSTableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        createPoolPropertiesHeaderTable()
    }

    func createPoolPropertiesHeaderTable() {
        if (zfsPoolsHeader != nil ) {
            poolsTableView.dataSource = self
            poolsTableView.delegate = self
            let columns = poolsTableView.tableColumns
            for column in columns {
                poolsTableView.removeTableColumn(column)
            }
            for heading in zfsPoolsHeader! {
                let newColumn = NSTableColumn(identifier: NSUserInterfaceItemIdentifier(rawValue: heading))
                newColumn.tableView = poolsTableView
                newColumn.title = heading
                newColumn.sizeToFit()
                newColumn.minWidth = 50
                poolsTableView.addTableColumn(newColumn)
            }
        }
    }
}
