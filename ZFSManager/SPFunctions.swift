//
//  SPFunctions.swift
//  sequel-pro
//
//  Created by Max Lohrmann on 01.10.15.
//  Copyright (c) 2015 Max Lohrmann. All rights reserved.
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

import Security

/**
 * Synchronously execute a block on the main thread.
 * This function can be called from a background thread as well as from
 * the main thread.
 */

func SPMainQSync(block: ) {
    if dispatch_get_current_queue() == DispatchQueue.main {
        block()
    } else {
        DispatchQueue.main.sync(execute: block)
    }
}

/**
 * Asynchronously execute a block on the main run loop.
 * This function is equivalent to calling -[[NSRunLoop mainRunLoop] performBlock:] on 10.12+
 */
func SPMainLoopAsync(block: ) {
    let modes = [.default] as? [Any]
    CFRunLoopPerformBlock(CFRunLoopGetMain(), modes, block)
}

/**
 * Copies count bytes into buf provided by caller
 * @param buf Base address to copy to
 * @param count Number of bytes to copy
 * @return 0 on success or -1 if something went wrong, check errno
 */
func SPBetterRandomBytes(buf: UnsafeMutablePointer<UInt8>?, count: size_t) -> Int {
    if SPOSInfo.isOSVersion(atLeastMajor: 10, minor: 7, patch: 0) {
        return SecRandomCopyBytes(kSecRandomDefault, count, buf)
    }

    // Version for 10.6
    // https://developer.apple.com/library/prerelease/mac/documentation/Security/Conceptual/cryptoservices/RandomNumberGenerationAPIs/RandomNumberGenerationAPIs.html#//apple_ref/doc/uid/TP40011172-CH12-SW1
    let fp: FILE? = fopen("/dev/random", "r")

    if fp == nil {
        return -1
    }

    var i: size_t
    for i in 0..<count {
        let c = fgetc(fp)
        if c == EOF {
            // /dev/random should never EOF
            errno = ferror(fp)
            return -1
        }
        buf?[i] = c
    }

    fclose(fp)

    return 0
}

/**
 * Convert a signed integer into an unsigned integer or throw an exception if the values don't fit.
 * @param i a signed integer
 * @return the same value, casted to unsigned integer
 */
func SPIntS2U(i: Int) -> Int {
    if i < 0 {
        NSException.raise(NSExceptionName.rangeException, format: "NSInteger %ld does not fit in NSUInteger", i)
    }

    return i
}

/**
 * Converts nil to NSNull for passing into arrays
 * @return The object that was passed in or [NSNull null] if object == nil
 * @see -[SPObjectAdditions unboxNull]
 */
func SPBoxNil(object: Any?) -> Any? {
    if object == nil {
        return NSNull()
    }

    return object
}