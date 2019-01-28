//
// Created by Dave Carlton on 2019-01-23.
// Copyright (c) 2019 Dave Carlton. All rights reserved.
//

import Cocoa

class ZFSSplitView: NSSplitView, NSSplitViewDelegate {
//    weak var delegate: NSSplitViewDelegate?
    @IBOutlet var collapseToggleButton: NSButton!
    @IBOutlet var additionalDragHandleView: NSView!
    var collapsibleSubviewIndex: Int = 0
    var collapsibleSubviewCollapsed = false
    var animationStartTime: Double = 0.0
    var animationDuration: Double = 0.0
    var animationTimer: Timer?
    var animationRetainCycleBypassObject: SPSplitViewAnimationRetainCycleBypass?
    var animationStartSize: Float = 0.0
    var animationTargetSize: Float = 0.0
    var viewMinimumSizes: [AnyHashable] = []
    var viewMaximumSizes: [AnyHashable] = []
}


class SPSplitViewAnimationRetainCycleBypass: NSObject {
    var parentSplitView: ZFSSplitView?

    init(parent aSplitView: ZFSSplitView?) {
    }

    func _animationStep(_ aTimer: Timer?) {
    }
}

