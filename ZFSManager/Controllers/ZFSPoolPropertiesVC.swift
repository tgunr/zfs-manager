//
//  ZFSPoolPropertiesVC.swift
//  ZFSManager
//
//  Created by Dave Carlton on 2/23/19.
//  Copyright © 2019 Dave Carlton. All rights reserved.
//

import Cocoa

class ZFSPoolPropertiesVC: ZFSPoolVC {
    var delegate: ZFSMainPoolVC?
    
    @IBOutlet weak var poolPropsHeaderView: NSTableHeaderView!
    @IBOutlet weak var poolPropTableView: NSTableView!
    @IBOutlet weak var poolOKButton: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        poolPropTableView.dataSource = self
        poolPropTableView.delegate = self
    }

    @IBAction func okClick(_ sender: Any) {
        self.dismiss(sender)
    }

    func tableView(_ tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView? {
        fatalError("tableView(_:rowViewForRow:) has not been implemented")
    }

    func tableView(_ tableView: NSTableView, willDisplayCell cell: Any, for tableColumn: NSTableColumn?, row: Int) {
    }


    func tableView(_ tableView: NSTableView, didClick tableColumn: NSTableColumn) {
    }

    func numberOfRows(in tableView: NSTableView) -> Int {
        let numRows = zfsPools?.pools?[0].properties.count
        print("numRows: \(String(describing: numRows))")
        return numRows!
    }

    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        if let index = delegate?.selectedIndex {
            let thePool = zfsPools?.pools?[index]
            let prop = thePool?.properties[row]
            for aPropElement in prop! {
                if aPropElement.name == tableColumn?.title.uppercased() {
                    return aPropElement.value
                }
            }
//            print("row: \(row) column: \(String(describing: tableColumn?.title))")
        }
        return nil
    }

    func createPoolPropertiesHeaderTable() {
        if let zfsPoolsHeader = zfsPools?.zpoolsHeadings {
            let columns = poolPropTableView.tableColumns
            for column in columns {
                poolPropTableView.removeTableColumn(column)
            }
            for heading in zfsPoolsHeader {
                let newColumn = NSTableColumn(identifier: NSUserInterfaceItemIdentifier(rawValue: heading))
                newColumn.tableView = poolPropTableView
                newColumn.title = heading
                newColumn.sizeToFit()
                newColumn.minWidth = 50
                poolPropTableView.addTableColumn(newColumn)
            }
        }
    }
}
