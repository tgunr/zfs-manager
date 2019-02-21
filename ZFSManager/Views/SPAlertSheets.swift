//
//  SPAlertSheets.swift
//  sequel-pro
//
//  Created by Rowan Beentje on January 20, 2010.
//  Copyright (c) 2010 Rowan Beentje. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//
//  More info at <https://github.com/sequelpro/sequelpro>
import Cocoa

class SPAlertSheets: NSObject {
    
    func beginWaitingAlertSheet(withTitle title: String?, defaultButton: String?, alternateButton: String?, otherButton: String?, alert alertStyle: NSAlert.Style, docWindow: NSWindow?, modalDelegate: Any?, didEnd didEndSelector: Selector, contextInfo: UnsafeMutableRawPointer?, infoText: String?, returnCode: UnsafeMutablePointer<Int>?) {
        
        /*
         var theReturnCode = returnCode
         
         // Ensure execution on the main thread
         /*
         if !Thread.current.isMainThread {
         return self.onMainThread()?.beginWaitingAlertSheet(withTitle: title, defaultButton: defaultButton, alternateButton: alternateButton, otherButton: otherButton, alert: alertStyle, docWindow: docWindow, modalDelegate: modalDelegate, didEnd: didEndSelector, contextInfo: contextInfo, infoText: infoText, returnCode: returnCode)
         }
         */
         
         var aButton: NSButton?
         
         // Initialize returnCode with a value which can't be returned as
         // returnCode in the didEndSelector method
         var initialReturnCode: Int = -5
         theReturnCode = UnsafeMutablePointer(initialReturnCode)
         
         // Set up an NSAlert with the supplied details
         let alert = NSAlert()
         alert.messageText = title ?? ""
         
         aButton = alert.addButton(withTitle: defaultButton ?? "")
         aButton?.tag = NSAlertDefaultReturn
         
         // Add 'alternate' and 'other' buttons as appropriate
         if alternateButton != nil {
         aButton = alert.addButton(withTitle: alternateButton ?? "")
         aButton?.tag = NSAlertAlternateReturn
         }
         
         if otherButton != nil {
         aButton = alert.addButton(withTitle: otherButton ?? "")
         aButton?.tag = NSAlertOtherReturn
         }
         
         // Set alert  style
         alert.alertStyle = alertStyle != nil ? alertStyle : NSWarningAlertStyle
         
         // Set the informative message if supplied
         if infoText != nil {
         alert.informativeText = infoText ?? ""
         }
         
         // Run the alert on the main thread
         if let docWindow = docWindow {
         alert.beginSheetModal(for: docWindow, modalDelegate: modalDelegate, didEnd: didEndSelector, contextInfo: contextInfo)
         }
         
         // wait for the sheet
         let session: NSApplication.ModalSession = NSApp.beginModalSession(for: alert.window)
         
         while true {
         
         // Since the returnCode can only be -1, 0, or 1
         // run the session until returnCode was changed in
         // the didEndSelector method of the calling class
         if Int(returnCode ?? 0) != initialReturnCode {
         break
         }
         
         // Execute code on DefaultRunLoop
         RunLoop.current.run(mode: .default, before: Date.distantFuture)
         
         // Break the run loop if sheet was closed
         if NSApp.run(session) != NSRunContinuesResponse || !alert.window.isVisible() {
         break
         }
         
         // Execute code on DefaultRunLoop
         RunLoop.current.run(mode: .default, before: Date.distantFuture)
         
         }
         
         NSApp.end(session)
         NSApp.endSheet(alert.window)
         }
         */
        
        /**
         * Provide a simple alias of a NSApp-wide modal NSBeginAlertSheet which waits
         * for a in calling class globally declared returnCode by reference which must
         * be changed in the didEndSelector of the calling class, with a few differences:
         *  - printf-type format strings are no longer supported within the "msg"
         *    message text argument, preventing access of random stack areas for
         *    error text which contains inadvertant printf formatting.
         *  - The didDismissSelector is no longer supported
         *  - The sheet no longer needs to be orderOut:ed after use
         *  - The alert is always shown on the main thread.
         */
    }
    
    func SPBeginAlertSheet(title: String?, defaultButton: String?, alternateButton: String?, otherButton: String?, docWindow: NSWindow?, modalDelegate: Any?, didEndSelector: Selector, contextInfo: UnsafeMutableRawPointer?, msg: String?) {
        // Set up an NSAlert with the supplied details
        let alert = NSAlert()
        
        alert.messageText = title ?? ""
        
        var aButton: NSButton = alert.addButton(withTitle: defaultButton ?? "")
        
        aButton.tag = NSAlertDefaultReturn
        
        // Add 'alternate' and 'other' buttons as appropriate
        if alternateButton != nil {
            aButton = alert.addButton(withTitle: alternateButton ?? "")
            aButton.tag = NSAlertAlternateReturn
        }
        
        if otherButton != nil {
            aButton = alert.addButton(withTitle: otherButton ?? "")
            aButton.tag = NSAlertOtherReturn
        }
        
        // Set the informative message if supplied
        if msg != nil {
            alert.informativeText = msg ?? ""
        }
        
        // Run the alert on the main thread
        if let docWindow = docWindow {
            alert.beginSheetModal(for: docWindow, modalDelegate: modalDelegate, didEnd: didEndSelector, contextInfo: contextInfo)
        }
        
        // Ensure the alerting window is frontmost
        docWindow?.makeKey()
    }
    
    func SPOnewayAlertSheet(title: String?, docWindow: NSWindow?, msg: String?) {
        SPOnewayAlertSheetWithStyle(title: title, defaultButton: nil, docWindow: docWindow, msg: msg, alertStyle:
            NSAlert.Style.warning)
    }
    
    func SPOnewayAlertSheetWithStyle(title: String?, defaultButton: String?, docWindow: NSWindow?, msg: String?, alertStyle: NSAlert.Style) {
        let defaultText = (defaultButton) != nil ? defaultButton : NSLocalizedString("OK", comment: "OK button")
        
        // Set up an NSAlert with the supplied details
        let alert = NSAlert()
        alert.messageText = title ?? ""
        
        let aButton: NSButton = alert.addButton(withTitle: defaultText ?? "")
        aButton.tag = NSAlertDefaultReturn
        
        // Set the informative message if supplied
        if msg != nil {
            alert.informativeText = msg ?? ""
        }
        
        // Set style (Defaults to NSWarningAlertStyle)
        alert.alertStyle = alertStyle
        
        // Run the alert
        alert.beginSheetModal(for: docWindow!, modalDelegate: nil, didEnd: nil, contextInfo: nil)
        alert.runModal()
    }
}

/**
 * Shorthand for SPOnewayAlertSheetWithStyle() with defaultButton=nil and alertStyle=NSWarningAlertStyle
 */

/**
 * A Send-and-forget variant for displaying alerts.
 * It will queue the alert on the main thread and *always* immediately return.
 *   Because of that there is no way to set a delegate and callback method
 * and there is only one default button.
 * If nil is passed as the button title it will be changed to @"OK".
 * If nil is passed as the window NSAlert will be modal
 */

/**
 * Provide a simple alias of NSBeginAlertSheet, with a few differences:
 *  - printf-type format strings are no longer supported within the "msg"
 *    message text argument, preventing access of random stack areas for
 *    error text which contains inadvertant printf formatting.
 *  - The didDismissSelector is no longer supported
 *  - The sheet no longer needs to be orderOut:ed after use
 *  - The alert is always shown on the main thread.
 */

