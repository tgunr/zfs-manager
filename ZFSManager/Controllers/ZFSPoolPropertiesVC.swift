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

//    func tableView(_ tableView: NSTableView, dataCellFor tableColumn: NSTableColumn?, row: Int) -> NSCell? {
//        if let poolNum = delegate?.selectedIndex {
//            let thePool = delegate?.zfsPools?.pools?[row]
//            let prop = thePool?.properties[row]
//            for aProp in prop! {
//                if aProp.name == tableColumn?.title.uppercased() {
//                    return aProp.value
//                }
//            }
////            print("row: \(row) pool: \(String(describing: pool))")
////            let propName = pool?.properties[row]
//        }
//        return nil
////        let prop = zfsPools?.pools?[0].properties[0]
//    }

    func tableView(_ tableView: NSTableView, didClick tableColumn: NSTableColumn) {
    }

    func numberOfRows(in tableView: NSTableView) -> Int {
        let numRows = zfsPools?.pools?[0].properties.count
        print("numRows: \(String(describing: numRows))")
        return numRows!
    }

    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        let thePool = zfsPools?.pools?[(delegate?.selectedIndex)!]
        let prop = thePool?.properties[row]
        for aProp in prop! {
            if aProp.name == tableColumn?.title.uppercased() {
                return aProp.value
            }
        }
//        print("row: \(row) column: \(String(describing: tableColumn?.title))")
        return nil
    }

    func createPoolPropertiesHeaderTable() {
        if (zfsPoolsHeader != nil ) {
            let columns = poolPropTableView.tableColumns
            for column in columns {
                poolPropTableView.removeTableColumn(column)
            }
            for heading in zfsPoolsHeader! {
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
