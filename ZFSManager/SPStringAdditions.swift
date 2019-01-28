//
//  SPStringAdditions.swift
//  sequel-pro
//
//  Created by Stuart Connolly (stuconnolly.com) on January 28, 2009.
//  Copyright (c) 2009 Stuart Connolly. All rights reserved.
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
 * NSStringUTF8String(@"a String") function can be used to speed up
 * the convertion from a NSString to NSData or const char* resp.
 * NSData *d = [aStr UTF8String];  :== NSData *d = NSStringUTF8String(aStr);
 */
//    typedef const char* (*SPUTF8StringMethodPtr)(NSString*, SEL);
/*
private let SPNSStringGetUTF8String: [Any] = []
let to_return = Int8()

//@inline(__always) private func (NSString() -> UnsafePointer<Int8>? {
//}
private var SPNSStringGetUTF8String: SPUTF8StringMethodPtr?

let to_return = SPNSStringGetUTF8String?(self, #selector(self.utf8CString))

private var SPMutableAttributedStringAddAttributeValueRange: SPMutableAttributedStringAddAttributeValueRangeMethodPtr?
private var SPMutableAttributedStringAttributeAtIndex: SPMutableAttributedStringAttributeAtIndexMethodPtr?
var r = SPMutableAttributedStringAttributeAtIndex?(self, #selector(self.attribute(_:at:effectiveRange:)), aStr, anIndex, aRange)

@inline(__always) private func (NSString() -> UnsafePointer<Int8>? {
}

@inline(__always) private func (NSMutableAttributedString() -> void NSMutableAttributedStringAddAttributeValueRange {
    self, NSString * aStr, id
}
*/
import Foundation

extension String {
    /*
    init(for byteSize: Int64) {
        var size = Double(byteSize)

        let numberFormatter = NumberFormatter()

        numberFormatter.numberStyle = .decimal

        if size < 1023 {
            numberFormatter.format = "#,##0 B"

            numberFormatter.string(from: NSNumber(value: size))
        }

        size = size / 1024

        if size < 1023 {
            numberFormatter.format = "#,##0.0 KiB"

            numberFormatter.string(from: NSNumber(value: size))
        }

        size = size / 1024

        if size < 1023 {
            numberFormatter.format = "#,##0.0 MiB"

            numberFormatter.string(from: NSNumber(value: size))
        }

        size = size / 1024

        if size < 1023 {
            numberFormatter.format = "#,##0.0 GiB"

            numberFormatter.string(from: NSNumber(value: size))
        }

        size = size / 1024

        numberFormatter.format = "#,##0.0 TiB"

        numberFormatter.string(from: NSNumber(value: size))
    }
    */

    /*
    init(for timeInterval: Double) {
        let numberFormatter = NumberFormatter()

        numberFormatter.numberStyle = .decimal

        // For time periods of less than one millisecond, display a localised "< 0.1 ms"
        if timeInterval < 0.0001 {
            numberFormatter.format = "< #,##0.0 ms"

            numberFormatter.string(from: NSNumber(value: 0.1))
        }

        if timeInterval < 0.1 {
            let aTimeInterval = timeInterval * 1000
            numberFormatter.format = "#,##0.0 ms"

            numberFormatter.string(from: NSNumber(value: aTimeInterval))
        }
        if timeInterval < 1 {
            let aTimeInterval = timeInterval * 1000
            numberFormatter.format = "#,##0 ms"

            numberFormatter.string(from: NSNumber(value: aTimeInterval))
        }

        if timeInterval < 10 {
            numberFormatter.format = "#,##0.00 s"

            numberFormatter.string(from: NSNumber(value: timeInterval))
        }

        if timeInterval < 100 {
            numberFormatter.format = "#,##0.0 s"

            numberFormatter.string(from: NSNumber(value: timeInterval))
        }

        if timeInterval < 300 {
            numberFormatter.format = "#,##0 s"

            numberFormatter.string(from: NSNumber(value: timeInterval))
        }

        if timeInterval < 3600 {
            let aTimeInterval = timeInterval / 60
            numberFormatter.format = "#,##0 min"

            numberFormatter.string(from: NSNumber(value: aTimeInterval))
        }

        let aTimeInterval = timeInterval / 3600

        numberFormatter.format = "#,##0 hours"

        numberFormatter.string(from: NSNumber(value: timeInterval))
    }
    */

    /*
    init() {
        // Create a new UUID
        let uuidObj = CFUUIDCreate(nil)

        // Get the string representation of the UUID
        let newUUID = CFUUIDCreateString(nil, uuidObj) as? String

        newUUID
    }
    */

    func rot13() -> String? {
        var theChar: unichar
        var holder = ""

        for i in 0..<count {
            let aChar = self[index(startIndex, offsetBy: i)]
            theChar = unichar(String(aChar)) ?? 0

            if theChar <= 122 && theChar >= 97 {
                if Int(theChar + 13) > 122 {
                    theChar -= unichar(13)
                } else {
                    theChar += unichar(13)
                }

                holder += "\(theChar)"
            } else if theChar <= 90 && theChar >= 65 {
                if Int(theChar) + 13 > 90 {
                    theChar -= unichar(13)
                } else {
                    theChar += unichar(13)
                }

                holder += "\(theChar)"
            } else {
                holder += "\(theChar)"
            }
        }

        let result = holder

        return result
    }

    func htmlEscape() -> String? {
        var mutableString = self as String

        if let subRange = Range<String.Index>(NSRange(location: 0, length: mutableString.count), in: mutableString) { mutableString = mutableString.replacingOccurrences(of: "&", with: "&amp;", options: .literal, range: subRange) }

        if let subRange = Range<String.Index>(NSRange(location: 0, length: mutableString.count), in: mutableString) { mutableString = mutableString.replacingOccurrences(of: "<", with: "&lt;", options: .literal, range: subRange) }

        if let subRange = Range<String.Index>(NSRange(location: 0, length: mutableString.count), in: mutableString) { mutableString = mutableString.replacingOccurrences(of: ">", with: "&gt;", options: .literal, range: subRange) }

        if let subRange = Range<String.Index>(NSRange(location: 0, length: mutableString.count), in: mutableString) { mutableString = mutableString.replacingOccurrences(of: "\"", with: "&quot;", options: .literal, range: subRange) }

        return mutableString
    }

    func backtickQuotedString() -> String? {
        return "`\(replacingOccurrences(of: "`", with: "``"))`"
    }

    func tickQuotedString() -> String? {
        return "'\(replacingOccurrences(of: "'", with: "''"))'"
    }

    func replaceUnderscoreWithSpace() -> String? {
        return replacingOccurrences(of: "_", with: " ")
    }

    func lineRanges(for aRange: NSRange) -> [Any]? {
        var currentLineRange: NSRange
        var lineRangesArray: [AnyHashable] = []

        // Check that the range supplied is valid - if not return an empty array.
        if Int(aRange.location) == NSNotFound || NSMaxRange(aRange) > count {
            return lineRangesArray
        }

        // Get the range of the first string covered by the specified range, and add it to the array
        currentLineRange = (self as NSString).lineRange(for: NSRange(location: Int(aRange.location), length: 0))

        lineRangesArray.append(NSStringFromRange(currentLineRange))

        // Loop through until the line end matches or surpasses the end of the specified range
        while NSMaxRange(currentLineRange) < NSMaxRange(aRange) {
            currentLineRange = (self as NSString).lineRange(for: NSRange(location: NSMaxRange(currentLineRange), length: 0))

            lineRangesArray.append(NSStringFromRange(currentLineRange))
        }

        // Return the constructed array of ranges
        return lineRangesArray
    }

    /*
    func createViewSyntaxPrettifier() -> String? {
        let searchRange = NSRange(location: 0, length: count)
        var matchedRange: NSRange
        var tblSyntax = String(repeating: "\0", count: count)
        let re = "(.*?) AS select (.*?) (from.*)"

        // Create view syntax
        matchedRange = rangeOfRegex(re, options: ([.rklMultiline, .rklDotAll]), in: searchRange, capture: 1, error: nil)

        if matchedRange.length == 0 || Int(matchedRange.length) > count {
            return description
        }

        tblSyntax += (self as NSString).substring(with: matchedRange)
        tblSyntax += "\nAS SELECT\n   "

        // Match all column definitions, split them by ',', and rejoin them by '\n'
        matchedRange = rangeOfRegex(re, options: ([.rklMultiline, .rklDotAll]), in: searchRange, capture: 2, error: nil)

        if matchedRange.length == 0 || Int(matchedRange.length) > count {
            return description
        }

        tblSyntax += (((self as NSString).substring(with: matchedRange)).components(separatedBy: "`,`")).joined(separator: "`,\n   `")

        // FROM ... on a new line
        matchedRange = rangeOfRegex(re, options: ([.rklMultiline, .rklDotAll]), in: searchRange, capture: 3, error: nil)

        if matchedRange.length == 0 || Int(matchedRange.length) > count {
            return description
        }

        var from = (self as NSString).substring(with: matchedRange)

        // Uppercase FROM
        if let subRange = Range<String.Index>(NSRange(location: 0, length: 4), in: from) { from.replaceSubrange(subRange, with: "FROM") }

        tblSyntax += "\n"
        tblSyntax += from

        // Where clause at a new line if given
        if let subRange = Range<String.Index>(NSRange(location: 0, length: tblSyntax.count), in: tblSyntax) { tblSyntax = tblSyntax.replacingOccurrences(of: " WHERE (", with: "\nWHERE (", options: .literal, range: subRange) }

        return tblSyntax
    }
    */

    /*
    func getGeomFromTextString() -> String? {
        let geomStr = trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

        if (self as NSString).range(of: ")").length == 0 || count < 5 {
            return "NULL"
        }

        // No SRID
        if geomStr.hasSuffix(")") {
            return "GeomFromText('\(geomStr)')"
        } else {
            let idx: Int = geomStr.count - 1

            while idx > 1 {
                if geomStr[geomStr.index(geomStr.startIndex, offsetBy: UInt(idx))] == ")" {
                    break
                }

                idx -= 1
            }

            return "GeomFromText('\((geomStr as? NSString)?.substring(to: idx + 1) ?? "")'\((geomStr as? NSString)?.substring(from: idx + 1) ?? ""))"
        }
    }

    func stringByRemovingCharacters(in charSet: CharacterSet?) -> String? {
        return stringByRemovingCharacters(in: charSet, options: 0)
    }
    */

    /*
    func stringByRemovingCharacters(in charSet: CharacterSet?, options mask: Int) -> String? {
        let len: Int = count
        var newString = ""

        mask &= ~.backwards.rawValue
        var range = NSRange(location: 0, length: len)

        while range.length {
            var substringRange: NSRange
            let pos = Int(range.location)

            if let charSet = charSet {
                range = (self as NSString).rangeOfCharacter(from: charSet, options: NSString.CompareOptions(rawValue: mask), range: range)
            }

            if Int(range.location) == NSNotFound {
                range = NSRange(location: len, length: 0)
            }

            substringRange = NSRange(location: pos, length: Int(range.location) - pos)

            newString += (self as NSString).substring(with: substringRange)

            range.location += range.length
            range.length = UInt(len - Int(range.location))
        }

        return newString
    }
    */

    /**
     * Replace all occurances of any character in set with the replacement string
     * @param set    Characters to look for (MUST NOT be nil)
     * @param string A replacement string (can be nil == empty string)
     * @return A string with replacements applied
     */
    /*
    func stringByReplacingCharacters(in `set`: CharacterSet?, with string: String?) -> String? {
        let len: Int = count
        var newString = ""

        var range = NSRange(location: 0, length: len)

        while true {
            var substringRange: NSRange
            let pos = Int(range.location)
            var endAfterInsert = false

            if let set = `set` {
                range = (self as NSString).rangeOfCharacter(from: set, options: [], range: range)
            }

            if Int(range.location) == NSNotFound {
                // insert the current substring up to the end
                substringRange = NSRange(location: pos, length: len - pos)
                endAfterInsert = true
            } else {
                // insert the current substring up to range.location
                substringRange = NSRange(location: pos, length: Int(range.location) - pos)
            }

            newString += (self as NSString).substring(with: substringRange)

            if endAfterInsert {
                break
            }

            // insert the replacement character
            newString.appendOrNil(string)

            // continue after the replaced characters
            range.location += range.length
            range.length = UInt(len - Int(range.location))
        }
        return newString
    }
    */

    /*
    func levenshteinDistance(withWord stringB: String?) -> CGFloat {
        // Normalize strings
        var stringA = self as String

        stringA.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        stringB?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

        stringA = stringA.lowercased()
        stringB = stringB?.lowercased()

        var k: Int
        var i: Int
        var j: Int
        var cost: Int
        var d: Int?
        var distance: Int

        let n: Int = stringA.count
        let m: Int = stringB?.count ?? 0

        if n != 0 && m != 0 {
            d = calloc(m * n, MemoryLayout<Int>.size)

            for k in 0..<n {
                d?[k] = k
            }

            for k in 0..<m {
                d
                k.n() = k
            }

            for i in 1..<n {
                for j in 1..<m {
                    cost = (stringA[stringA.index(stringA.startIndex, offsetBy: UInt(i - 1))] == stringB?[stringB?.index(stringB?.startIndex, offsetBy: UInt(j - 1))]) ? 0 : 1

                    d?[j * n + i] = smallestOf((d?[(j - 1) * n + i] ?? 0) + 1, (d?[j * n + i - 1] ?? 0) + 1, (d?[(j - 1) * n + i - 1] ?? 0) + cost)
                }
            }

            distance = d?[n * m - 1] ?? 0

            free(d)

            return CGFloat(distance)
        }
        n += 1
        m += 1

        return 0.0
    }
    */

    /**
     * Checks if the string other is contained in self on a per-character basis.
     * In regex-speak that would mean "abc" is matched as /a.*b.*c/ (not anchored).
     * This is a SEARCH function, NOT a MATCHING function! 
     * Namely the following options will be applied when matching: 
     *   NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch|NSWidthInsensitiveSearch
     * Additionaly this method might match even when it should not.
     * A regular substring test is always included. Therefore looking e.g. for "abc" in
     * "axbxabc" would match as (axbx,"abc") and NOT as ("a",x,"b",xab,"c").
     * Partial submatches will likewise be optimized to return as few matches as possible.
     * E.g. ".123" in "a._1_12_123" will return (a,".",_1_12_,"123") NOT (a,".",_,"1",_1,"2",_12,"3")
     *
     * @param other      String to match against self
     * @param submatches Pass the pointer to a variable that will be set to an NSArray *
     *                   of NSValue *s of NSRanges. This will only be the case if
     *                   the method also returns YES. The variable will not be modified
     *                   otherwise.
     *                   Pass NULL if you don't care for the ranges.
     *                   The object will be set to autorelase.
     * @return YES if self contains all characters from other in the order given in other
     * @warning This method is NOT thread-safe (probably), NOT constant-time and DOES NOT check binary equivalence
     */
    /*
    func nonConsecutivelySearch(_ other: String?, matchingRanges submatches: [Any]?) -> Bool {
        let opts: NSString.CompareOptions = [.caseInsensitive, .diacriticInsensitive, .widthInsensitive]
        let recordMatches: Bool = submatches != nil //for readability
        let selfRange = NSRange(location: 0, length: count)

        //shortcut: * a longer string can never be contained in a shorter one.
        //          * nil can never match in a string.
        //          * an empty other can never match if self is non-empty
        if ((other?.count ?? 0) > count) || (!(other ?? "")) != "" || (count != 0 && (other?.count ?? 0) == 0) {
            return false
        }

        //handle the simple case via the default algorithm
        if compare(other ?? "", options: opts, range: nil, locale: .current) == .orderedSame {
            if recordMatches {
                submatches = [NSValue(range: selfRange)]
            }
            return true
        }

        // for now let's save the overhead of NSArray and NSValues
        let tmpMatchStore: NSRange? = recordMatches ? calloc((other?.count ?? 0), MemoryLayout<NSRange>.size) : nil
        var matchCount: Int = 0
        let searchRange: NSRange = selfRange

        //this looks a bit silly but is basically Apples approach to handling multibyte charsets
        let it: ((String?, NSRange, NSRange, UnsafeMutablePointer<ObjCBool>?) -> Void)? = { substring, substringRange, enclosingRange, stop in
                //look for the current character of other in the remaining part of self
                let found: NSRange = (self as NSString).range(of: substring ?? "", options: opts, range: searchRange)
                if Int(found.location) == NSNotFound {
                    matchCount = 0 //reset match count to "no match"
                    stop = true
                    return
                }
                if recordMatches {
                    tmpMatchStore?[matchCount] = found
                }
                matchCount += 1
                //move the next search past the current match
                searchRange.location = NSMaxRange(found)
                searchRange.length = UInt(self.count - Int(searchRange.location))
            }

        if let it = it {
            (other as NSString?)?.enumerateSubstrings(in: NSRange(location: 0, length: other?.count ?? 0), options: .byComposedCharacterSequences, using: it)
        }

        if matchCount != 0 && recordMatches {
            //we want to re-combine sub-matches that are actually consecutive

            //This algorithm uses a simple look-behind for merges:
            //  Object 1 checks if it continues object 0. If so, 1 and 0 will merge
            //  and be placed in the slot of 0 (slot 1 is now invalid).
            //  Then object 2 checks if it continues object 0. If it does not, it is
            //  placed in slot 1.
            //  Object 3 then checks if it continues object 1 and so on...
            let mergeTarget: Int = 0
            for i in 1..<matchCount {
                let prev: NSRange? = tmpMatchStore?[mergeTarget]
                let this: NSRange? = tmpMatchStore?[i]
                //if the previous match ends right before this match begins we can merge them
                if NSMaxRange(prev) == this?.location {
                    let mergedRange = NSRange(location: Int(prev?.location ?? 0), length: Int((prev?.length ?? 0) + (this?.length ?? 0)))
                    tmpMatchStore?[mergeTarget] = mergedRange
                } else {
                    mergeTarget += 1
                    if mergeTarget != i {
                        tmpMatchStore?[mergeTarget] = this
                    }
                }
            }
            matchCount = mergeTarget + 1

            //Next we want to merge non-adjacent matches that could be adjacent. Example:
            //  Haystack:    "central_private_rabbit_park"
            //  Needle:      "centralpark"
            //  Unoptimized: "central_private_rabbit_park"
            //                ^^^^^^^ ^   ^   ^         ^ = 5
            //  Desired:     "central_private_rabbit_park"
            //                ^^^^^^^                ^^^^ = 2
            //
            //  This time we start from the end (object K) and check if object K-1 can
            //  actually be placed directly in front of K and if so, merge them both into
            //  a new K-1 and shift down K+1 to K, K+2 to K+1, ...
            var k = matchCount - 1
            while k > 0 {
                let my: NSRange? = tmpMatchStore?[k]
                let prev: NSRange? = tmpMatchStore?[k - 1]
                var prevMatch: String? = nil
                if let prev = prev {
                    prevMatch = (self as NSString).substring(with: prev)
                }
                let `left` = NSRange(location: Int((my?.location ?? 0) - (prev?.length ?? 0)), length: Int(prev?.length ?? 0))
                let myLeftSide = (self as NSString).substring(with: `left`)
                if prevMatch?.compare(myLeftSide, options: opts, range: nil, locale: .current) == .orderedSame {
                    //yay, let's merge them
                    tmpMatchStore?[k - 1] = NSRange(location: Int(`left`.location), length: Int((my?.length ?? 0) + (prev?.length ?? 0)))
                    //we now have to shift down k+1 to k, k+2 to k+1, ...
                    for n in k + 1..<matchCount {
                        tmpMatchStore?[n - 1] = tmpMatchStore?[n]
                    }
                    //merging means one match less in total
                    matchCount -= 1
                }
                k -= 1
            }

            var combinedArray = [AnyHashable](repeating: 0, count: matchCount)
            for j in 0..<matchCount {
                if let j = tmpMatchStore?[j] {
                    combinedArray.append(NSValue(range: j))
                }
            }

            submatches = combinedArray
        }

        free(tmpMatchStore) // free(NULL) is safe as per OS X man page
        return matchCount > 0
    }
    */

    /*
     * Returns a human readable version string of the supplied byte size.
     */
    /**
     * Returns a human readable version string of the supplied time interval.
     */
    /**
     * Returns a new created UUID string.
     */
    /**
     * Returns the ROT13 representation of self.
     */
    /**
     * Escapes HTML special characters.
     */
    /**
     * Returns the string quoted with backticks as required for MySQL identifiers.
     *
     * eg.: tablename    =>   `tablename`
     *      my`table     =>   `my``table`
     */
    /**
     * Returns the string quoted with ticks as required for MySQL identifiers.
     *
     * eg.: tablename    =>   'tablename'
     *      my'table     =>   'my''table'
     */
    /**
     * Replaces an occurrences of underscores with a single space.
     */
    /**
     * Returns a more readable version of a 'CREATE VIEW SYNTAX' string.
     *
     * If the string doesn't match it returns the unchanged string.
     */
    /**
     * Returns an array of serialised NSRanges, each representing a line within the string
     * which is at least partially covered by the NSRange supplied.
     * Each line includes the line termination character(s) for the line.  As per
     * lineRangeForRange, lines are split by CR, LF, CRLF, U+2028 (Unicode line separator),
     * or U+2029 (Unicode paragraph separator).
     */
    /**
     * Returns the string by removing the characters in the supplied set and options.
     */
    /**
     * Convenience method to access the above method with no options.
     */
    /**
     * Calculate the distance between two string case-insensitively.
     */
    /**
     * Create the GeomFromText() string according to a possible SRID value
     */
}

extension String {
    /**
     * nil-safe variant of setString:
     * nil will be interpreted as @"" instead of throwing an exception
     */
    /*
    func setStringOrNil(_ aString: String?) {
        self = (aString != nil ? aString : "")
    }
    */

    /**
     * nil-safe variant of appendString: 
     * nil will be interpreted as @"" instead of throwing an exception
     */
    /*
    func appendOrNil(_ aString: String?) {
        self += (aString != nil ? aString : "") ?? ""
    }
    */
}

/**
 * Returns the minimum of a, b and c.
 */
private func smallestOf(a: Int, b: Int, c: Int) -> Int {
    var min: Int = a

    if b < min {
        min = b
    }

    if c < min {
        min = c
    }

    return min
}
