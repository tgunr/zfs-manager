//
//  SPMainThreadTrampoline.swift
//  sequel-pro
//
//  Created by Rowan Beentje on March 20, 2010.
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

/**
 * Set up the categories, available on all NSObjects.
 */
import Foundation

extension NSObject {
    func onMainThread() -> Any? {

        // Return an autoreleased trampoline object
        return SPMainThreadTrampoline(object: self)
    }

    func retainedOnMainThread() -> Any? {
        return SPMainThreadTrampoline(object: self)
    }

    /**
     * Provide a category on all NSObjects to return a trampoline for that
     * object on the main thread.
     * This cannot be retained or released.
     */
    /**
     * Provide a retained version of the category
     */
}

/**
 * Set up the trampoline class.
 * This is created automatically by using the onMainThread category; all messages
 * sent to this object are bounced to the initial object on the main thread.
 * Note that base NSObject messages like retain or release apply to the trampoline.
 */
class SPMainThreadTrampoline: NSObject {
    @IBOutlet var trampolineObject: Any!

    init(object theObject: Any) {
        //if super.init()
        trampolineObject = theObject
    }

    /**
     * The master initiliasation - the category implementation calls this
     * with the requested object.
     */
    /**
     * Delegate unrecognised methods to the trampolined objects, thanks to the magic
     * of NSInvocation (see forwardInvocation: docs for background). Must be paired
     * with methodSignationForSelector:.
     */
    /*
    func forwardInvocation(_ theInvocation: NSInvocation) {
        let theSelector: Selector = theInvocation.selector()
        if !trampolineObject.responds(to: theSelector) {
            doesNotRecognizeSelector(theSelector)
        }

        // Retain the arguments and object for the call for safety
        theInvocation.retainArguments()
        trampolineObject
        theInvocation.performSelector(onMainThread: #selector(SPMainThreadTrampoline.invoke(withTarget:)), with: trampolineObject, waitUntilDone: true)
    }
    */

    /**
     * Return the correct method signatures for the trampolined object if
     * NSObject doesn't implement the requested methods.
     */
    /*
    func methodSignature(for theSelector: Selector) -> NSMethodSignature? {
        let defaultSignature: NSMethodSignature? = super.methodSignature(for: theSelector)
        if defaultSignature != nil {
            return defaultSignature
        }

        return trampolineObject.methodSignature(for: theSelector)
    }
    */

    /**
     * Override the default repondsToSelector:, returning true if either NSObject
     * or the trampolined object supports the selector.
     */
    /*
    override func responds(to theSelector: Selector!) -> Bool {
        return super.responds(to: theSelector) || self.trampolineObject.responds(to: theSelector)
    }
    */

    /**
     * Override the default performSelector:, again either using NSObject defaults
     * or performing the selector on the trampolined object.
     * Note that the return value from the trampolined object is not preserved in this case.
     */
    /*
    override func perform(_ theSelector: Selector!) -> Unmanaged<AnyObject>! {
        if super.responds(to: theSelector) {
            return super.perform(theSelector)
        }

        if !trampolineObject.responds(to: theSelector) {
            doesNotRecognizeSelector(theSelector)
        }

        // Retain the object while performing calls on it
        trampolineObject
        trampolineObject.performSelector(onMainThread: theSelector, with: nil, waitUntilDone: true)

        return nil
    }
    */

    /**
     * Override the default performSelector:withObject: - see performSelector:
     * Note that the return value from the trampolined object is not preserved in this case.
     */
    /*
    override func perform(_ theSelector: Selector!, with theObject: Any!) -> Unmanaged<AnyObject>! {
        if super.responds(to: theSelector) {
            return super.perform(theSelector, with: theObject)
        }

        if !trampolineObject.responds(to: theSelector) {
            doesNotRecognizeSelector(theSelector)
        }

        // Retain the trampolined object, and the argument object, while performing calls
        trampolineObject
        theObject
        trampolineObject.performSelector(onMainThread: theSelector, with: theObject, waitUntilDone: true)

        return nil
    }
    */

    /**
     * If the trampoline is sent the onMainThread category, just return the trampoline directly.
     */
    /*
    override func onMainThread() -> Any? {
        return self
    }
    */
}
