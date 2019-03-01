//
// Created by Dave Carlton on 2019-02-22.
// Copyright (c) 2019 Dave Carlton. All rights reserved.
//

import Cocoa

class ZFSPoolVC: ZFSMainTabViewController, NSTableViewDelegate, NSTableViewDataSource, NSOutlineViewDelegate, NSOutlineViewDataSource {
    private var appDelegate = NSApplication.shared.delegate as! AppDelegate
    var poolStrings: [String]?
    var zfsPools: ZFSPools?
    var poolNames: [String]?

    override func viewDidLoad() {
        super.viewDidLoad()
        zfsPools = ZFSPools()
        appDelegate.pools = zfsPools
    }

}

class ZFSMainPoolVC: ZFSPoolVC {
    var selectedIndex: Int?
    var selectedPool: String?
    
    @IBOutlet weak var poolsSourceList: NSOutlineView!
    @IBOutlet weak var poolsTableHeaderView: NSTableHeaderView!
    @IBOutlet weak var poolsTableView: NSTableView!

    @IBAction func poolsAction(_ sender: Any) {
        selectedIndex = poolsSourceList.selectedRow
        selectedPool = zfsPools?.pools?[selectedIndex!].name
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        createPoolsHeaderTable()
    }

    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        let destController = segue.destinationController as! ZFSPoolPropertiesVC
        destController.delegate = self
    }

    func createPoolsHeaderTable() {
        if let zfsPoolsHeader = zfsPools?.zpoolsHeadings {
            poolsTableView.dataSource = self
            poolsTableView.delegate = self
            let columns = poolsTableView.tableColumns
            for column in columns {
                poolsTableView.removeTableColumn(column)
            }
            for heading in zfsPoolsHeader {
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
    // MARK: -
    // MARK: DataSource

    func numberOfRows(in tableView: NSTableView) -> Int {
        return zfsPools?.pools?.count ?? 0
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        let key: String = (tableColumn?.identifier.rawValue)!
        let pool = zfsPools?.pools?[row]
        var i = 0
        for id in pool?.data ?? [] {
            let aName = id.name
            if aName == key {
                return id.value
            }
            i += 1
        }
        return nil
    }
    
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        if zfsPools == nil {
            zfsPools = ZFSPools()
        }
        return zfsPools?.pools?.count ?? 0
    }

    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        return zfsPools?.pools?[index].name as Any
    }

    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        return false
    }

    // MARK: -
    // MARK: Delegate Methods
    public func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        fatalError("tableView(_:shouldSelectRow:) has not been implemented")
    }

    public func tableView(_ tableView: NSTableView, didClick tableColumn: NSTableColumn) {
    }

    public func tableView(_ tableView: NSTableView, rowActionsForRow row: Int, edge: NSTableView.RowActionEdge) -> [NSTableViewRowAction] {
        fatalError("tableView(_:rowActionsForRow:edge:) has not been implemented")
    }

    public func tableViewSelectionIsChanging(_ notification: Notification) {
    }

    func outlineViewSelectionDidChange(_ notification: Notification) {
        guard let outlineView = notification.object as? NSOutlineView else {
            return
        }
        selectedIndex = outlineView.selectedRow
        selectedPool = zfsPools?.pools?[selectedIndex!].name
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
