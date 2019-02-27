//
// Created by Dave Carlton on 2019-02-22.
// Copyright (c) 2019 Dave Carlton. All rights reserved.
//

import Cocoa

class ZFSPoolVC: ZFSMainTabViewController, NSTableViewDelegate, NSTableViewDataSource, NSOutlineViewDelegate, NSOutlineViewDataSource {
    var poolStrings: [String]?
    var zfsPools: ZFSPools?
    var zfsPoolsHeader: [String]?
    var poolNames: [String]?

    override func viewDidLoad() {
        super.viewDidLoad()
        zfsPools = ZFSPools()
        zfsPoolsHeader = zfsPools?.headers
    }

}

class ZFSMainPoolVC: ZFSPoolVC {
    
    @IBOutlet weak var poolsSourceList: NSOutlineView!
    @IBOutlet weak var poolsTableHeaderView: NSTableHeaderView!
    @IBOutlet weak var poolsTableView: NSTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
                poolsTableView.addTableColumn(newColumn)
            }
        }
    }
}

extension ZFSMainPoolVC {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return zfsPools?.pools?.count ?? 0
    }
    
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
