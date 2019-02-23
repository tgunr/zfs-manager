//
// Created by Dave Carlton on 2019-02-22.
// Copyright (c) 2019 Dave Carlton. All rights reserved.
//

import Cocoa

class ZFSMainPoolViewController: ZFSMainTabViewController, NSOutlineViewDelegate, NSOutlineViewDataSource {
    var poolStrings: [String]?
    var pools: [Pool]?
    var poolsHeader: [String] = ["NAME", "SIZE", "ALLOC", "FREE", "CKPOINT", "EXPANDSZ", "FRAG", "CAP", "DEDUP", "HEALTH", "ALTROOT"]
    var poolNames: [String]?
    
    @IBOutlet weak var poolsSourceList: NSOutlineView!
    @IBOutlet weak var poolsTableHeaderView: NSTableHeaderView!
    @IBOutlet weak var poolsTableView: NSTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getPools()
        createPoolsHeaderTable()
    }

    func createPoolsHeaderTable() {
        if (pools != nil ) {
            poolsTableView.dataSource = self
            let columns = poolsTableView.tableColumns
            for column in columns {
                poolsTableView.removeTableColumn(column)
            }
            for heading in poolsHeader {
                let newColumn = NSTableColumn(identifier: NSUserInterfaceItemIdentifier(rawValue: heading))
                newColumn.tableView = poolsTableView
                newColumn.title = heading
                poolsTableView.addTableColumn(newColumn)
            }
        }
    }
    
    func getPools() {
        let result = shell(cmd: "/usr/local/bin/zpool", args: ["list", "-H"])
        if (result.exitCode == 0) {
            pools = []
            poolNames = []
            poolStrings = result.output
            
            for poolString in poolStrings ?? [] {
                let newPool = Pool().stringToPool(poolString: poolString)
                pools?.append(newPool)
                poolNames?.append(newPool.name)
            }
        }
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return pools?.count ?? 0
    }

    @IBAction func poolsAction(_ sender: NSOutlineView) {
    }
}

extension ZFSMainPoolViewController {
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        if pools == nil {
            getPools()
        }
        return poolNames?.count ?? 0
    }

    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        return pools?[index].name as Any
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
        let poolItem = item as? Pool
        return poolItem?.name
     }

}

extension ZFSMainPoolViewController {
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        var view: NSTableCellView?

        view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "HeaderCell"), owner: self) as? NSTableCellView
        if let textField = view?.textField {
            textField.stringValue = String(describing: item)
        }
        return view
    }
}
