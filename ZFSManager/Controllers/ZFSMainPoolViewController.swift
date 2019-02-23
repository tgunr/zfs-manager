//
// Created by Dave Carlton on 2019-02-22.
// Copyright (c) 2019 Dave Carlton. All rights reserved.
//

import Cocoa

class ZFSMainPoolViewController: ZFSMainTabViewController, NSTableViewDelegate, NSTableViewDataSource, NSOutlineViewDelegate, NSOutlineViewDataSource {
    var poolStrings: [String]?
    var zfsPools: ZFSPools?
    var zfsPoolsHeader: [String]?
    var poolNames: [String]?
    
    @IBOutlet weak var poolsSourceList: NSOutlineView!
    @IBOutlet weak var poolsTableHeaderView: NSTableHeaderView!
    @IBOutlet weak var poolsTableView: NSTableView!
    @IBAction func poolsAction(_ sender: NSOutlineView) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        zfsPools = ZFSPools()
        zfsPoolsHeader = zfsPools?.headers
        createPoolsHeaderTable()
    }

    func createPoolsHeaderTable() {
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
//                let headingSize = heading.count
                poolsTableView.addTableColumn(newColumn)
            }
        }
    }
    
    
//    func tableView(_ tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView? {
//        let newRowView = NSTableView().makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: String(row)), owner: self) as? NSTableRowView
//        if let poolData = zfsPools?.pools?[row].data {
//            _ = 0
//            for column in poolData {
//                let newColumn = NSTableColumn(identifier: NSUserInterfaceItemIdentifier(rawValue: column.key))
//                newColumn.sizeToFit()
//
//                let newTextView = NSText()
//                let something = column.value
//                newTextView.string = something
//                tableView.addTableColumn(colTable)
//            }
//        }
//
//        return newRowView
//    }

//    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
//        fatalError("tableView(_:objectValueFor:row:) has not been implemented")
//    }
}

extension ZFSMainPoolViewController {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return zfsPools?.pools?.count ?? 0
    }
    
    //    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
    //        let view = tableView.view(atColumn: Int((tableColumn?.identifier.rawValue)!)!, row: row, makeIfNecessary: true)
    //        return view
    //                fatalError("tableView(_:viewFor:row:) has not been implemented")
    //
    //    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        let key: String = (tableColumn?.identifier.rawValue)!
        let pool = zfsPools?.pools?[row]
        let value = pool?.data[key]
        return value
    }
    
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        if zfsPools == nil {
            zfsPools = ZFSPools()
            zfsPoolsHeader = zfsPools?.headers
        }
        return zfsPools?.pools?.count ?? 0
    }

    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        return zfsPools?.pools?[index].data["NAME"] as Any
    }

    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        return false
    }


    func outlineViewSelectionDidChange(_ notification: Notification) {
        guard let outlineView = notification.object as? NSOutlineView else {
            return
        }
        let selectedIndex = outlineView.selectedRow
    }

    func outlineView(_ outlineView: NSOutlineView, objectValueFor tableColumn:  NSTableColumn?,
     byItem item: Any?) -> Any? {
        let poolItem = item as? ZFSPool
        return poolItem?.name
     }

    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        var view: NSTableCellView?

        view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "HeaderCell"), owner: self) as? NSTableCellView
        if let textField = view?.textField {
            textField.stringValue = String(describing: item)
        }
        return view
    }
    

}
