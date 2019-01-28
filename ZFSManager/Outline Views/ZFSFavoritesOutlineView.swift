//
//  ZFSavoritesOutlineView.swift
//
import Cocoa

private var ZFSFavoritesOutlineViewUnindent: Int = 6

class ZFSFavoritesOutlineView: NSOutlineView {
    var isOSVersionAtLeast10_7_0 = false

    var justGainedFocus = false
    /**
     * The item on which the last doubleAction (double click or enter/return key) was performed.
     * May be nil.
     * This is only valid during the call to the doubleAction target!
     */
    private(set) var itemForDoubleAction: Any?
 //make setter private
    @objc override func awakeFromNib() {
        isOSVersionAtLeast10_7_0 = OSInfo.isOSVersion(atLeastMajor: 10, minor: 7, patch: 0)
    }

    @objc override var acceptsFirstResponder: Bool {
        if window?.firstResponder != self {
            self.justGainedFocus = true
        }

        return true
    }

    override func resignFirstResponder() -> Bool {
        self.justGainedFocus = false

        return super.resignFirstResponder()
    }

    /**
     * Right-click at row will select that row before ordering out the contextual menu
     * if not more than one row is selected.
     */
    @objc override func menu(for event: NSEvent) -> NSMenu? {
        // If more than one row is selected only return the default contextual menu
        if numberOfSelectedRows > 1 {
            return menu
        }

        // Right-click at a row will select that row before ordering out the context menu
        let row: Int = self.row(at: convert(event.locationInWindow, from: nil))

        if (row >= 0) && (row < numberOfRows) {
            selectRowIndexes(NSIndexSet(index: row) as IndexSet, byExtendingSelection: false)
            window?.makeFirstResponder(self)
        }

        return menu
    }

    override func keyDown(with event: NSEvent) {
        // Enter or Return initiates a connection to the selected favorite, which is the same as double-clicking
        // one, so call the same selector.
        if (numberOfSelectedRows == 1) && ((event.keyCode == 36) || (event.keyCode == 76)) {
            self.itemForDoubleAction = item(atRow: selectedRow)
            if let doubleAction = doubleAction {
                NSApp.sendAction(doubleAction, to: delegate, from: self)
            }
            self.itemForDoubleAction = nil
            return
        }
        // If the Tab key is used, change focus rather than entering edit mode.
        let start = event.characters?.startIndex
        let end = event.characters?.endIndex
        if (start != end) {
            let c = event.characters![start!] as Character
            if c  == Character(UnicodeScalar(NSTabCharacter)!) {
                window?.selectKeyView(following: self)
            } else {
                window?.selectKeyView(preceding: self)
            }
        }
        super.keyDown(with: event)
        return
    }

    override func mouseDown(with theEvent: NSEvent) {
        if (theEvent.type == .leftMouseDown && theEvent.clickCount == 2) {
            // The tricky thing is that [self clickedRow] is set from [NSTableView mouseDown], so right now it's not populated.
            // We can't use [self selectedRow] either, as clicking on empty space does not update the selection.
            let clickAt = theEvent.locationInWindow
            let relClickAt = self.convert(clickAt, from: nil)
            let rowNum: Int = row(at: relClickAt)
            if rowNum > -1 {
                self.itemForDoubleAction = item(atRow: rowNum)
            }
        }

        super.mouseDown(with: theEvent)

        self.itemForDoubleAction = nil // not much overhead, therefore unconditional
    }

    /**
     * To prevent right-clicking in a column's 'group' heading, ask the delegate if we support selecting it
     * as this normally doesn't apply to left-clicks. If we do support selecting this row, simply pass on the event.
     */
    override func rightMouseDown(with event: NSEvent) {
        if delegate?.responds(to: #selector(NSOutlineViewDelegate.outlineView(_:shouldSelectItem:))) ?? false {
            if let item = item(atRow: row(at: convert(event.locationInWindow, from: nil))) {
                if delegate?.outlineView!(self, shouldSelectItem: item) ?? false {
                    super.rightMouseDown(with: event)
                }
            }
        } else {
            super.rightMouseDown(with: event)
        }
    }

    /**
     * Disclosure triangles for the top-level items hae been removed, and similarly other
     * paddings need altering.  This involves increasing the padding - and reducing the width -
     * of all rows to compensate.
     */
    override func frameOfCell(atColumn columnIndex: Int, row rowIndex: Int) -> NSRect {
        let superFrame: NSRect = super.frameOfCell(atColumn: columnIndex, row: rowIndex)

        // On system versions lower than Lion, don't alter padding
        if !isOSVersionAtLeast10_7_0 {
            return superFrame
        }

        // Don't alter padding for the top-level items
        if delegate?.responds(to: #selector(NSOutlineViewDelegate.outlineView(_:isGroupItem:))) ?? false {
            if let item = item(atRow: rowIndex) {
                if delegate?.outlineView!(self, isGroupItem: item) ?? false {
                    return superFrame
                }
            }
        }

        return NSMakeRect(CGFloat(superFrame.origin.x + CGFloat(ZFSFavoritesOutlineViewUnindent)), superFrame.origin.y, superFrame.size.width - CGFloat(ZFSFavoritesOutlineViewUnindent), superFrame.size.height)
    }

    /**
     * Disclosure triangles for the top-level items have been removed, the frames for other
     * disclosure items need to be similarly moved.
     */
    override func frameOfOutlineCell(atRow rowIndex: Int) -> NSRect {
        let superFrame: NSRect = super.frameOfOutlineCell(atRow: rowIndex)

        // Return NSZeroRect if the row is a group row
        if delegate?.responds(to: #selector(NSOutlineViewDelegate.outlineView(_:isGroupItem:))) ?? false {
            if let item = item(atRow: rowIndex) {
                if delegate?.outlineView!(self, isGroupItem: item) ?? false {
                    return NSRect.zero
                }
            }
        }

        // On versions of Lion or above, amend the padding appropriately
        if isOSVersionAtLeast10_7_0 {
            return NSMakeRect(CGFloat(superFrame.origin.x + CGFloat(ZFSFavoritesOutlineViewUnindent)), superFrame.origin.y, superFrame.size.width, superFrame.size.height)
        }

        return superFrame
    }

    /**
     * If the delegate is a SPConnectionController, and editing is currently in
     * progress, draw a custom highlight.
     */
    override func highlightSelection(inClipRect clipRect: NSRect) {
        // Only proceed if a the delegate is a SPConnectionController and a favorite being edited
        if (delegate is ConnectionController) && (delegate as? ConnectionController)?.isEditingConnection != nil && (delegate as? ConnectionController)?.selectedFavorite() != nil {

            // Draw an editing dot instead of highlighting the whole row
            let rowRect: NSRect = rect(ofRow: selectedRow)
            let dotSize = Float(rowRect.size.height / 1.9)
            let dotRect: NSRect = NSMakeRect(9.0, rowRect.origin.y + ((rowRect.size.height - CGFloat(dotSize)) / 2), CGFloat(dotSize), CGFloat(dotSize))
            NSGraphicsContext.saveGraphicsState()

            let clipPath = NSBezierPath()
            clipPath.appendOval(in: dotRect)
            clipPath.addClip()

            let dotGradient = NSGradient(starting: NSColor(deviceRed: 0.44, green: 0.72, blue: 0.92, alpha: 1.0), ending: NSColor(deviceRed: 0.21, green: 0.53, blue: 0.82, alpha: 1.0))
            dotGradient?.draw(in: dotRect, angle: 90.0)

            NSGraphicsContext.restoreGraphicsState()

            return
        }

        super.highlightSelection(inClipRect: clipRect)
    }
}
