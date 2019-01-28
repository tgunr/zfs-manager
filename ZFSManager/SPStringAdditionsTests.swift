//
//  SPStringAdditionsTests.swift
//  sequel-pro
//
//  Created by Jim Knight on May 17, 2009.
//  Copyright (c) 2009 Jim Knight. All rights reserved.
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
//import XCTest

class SPStringAdditionsTests {
    /*
    func testStringByRemovingCharactersInSet() {
        let SPASCIITestString = "this is a big, crazy test st'ring  with som'e random  spaces and quot'es"
        let SPUTFTestString = "In der Kürze liegt die Würz"

        let charsToRemove = "abc',ü"

        let junk1 = Character.init("abc',ü")

        let actualUTFString = SPUTFTestString
        let actualASCIIString = SPASCIITestString

        let expectedUTFString = "In der Krze liegt die Wrz"
        let expectedASCIIString = "this is  ig rzy test string  with some rndom  spes nd quotes"

        XCTAssertEqual(actualASCIIString.stringByRemovingCharacters(in: junk), expectedASCIIString)

        XCTAssertEqual(actualUTFString.stringByRemovingCharacters(in: junk), expectedUTFString)
    }

    func testStringWithNewUUID() {
        let uuid = String()

        XCTAssertTrue(uuid?.isMatched(byRegex: "[A-F0-9]{8}-[A-F0-9]{4}-[A-F0-9]{4}-[A-F0-9]{4}-[A-F0-9]{12}"), "UUID %@ doesn't match regex", uuid)
    }

    func testCreateViewSyntaxPrettifier() {
        let originalSyntax = "CREATE VIEW `test_view` AS select `test_table`.`id` AS `id` from `test_table`;"
        let expectedSyntax = "CREATE VIEW `test_view`\nAS SELECT\n   `test_table`.`id` AS `id`\nFROM `test_table`;"

        let actualSyntax = originalSyntax.createViewSyntaxPrettifier()

        XCTAssertEqual(actualSyntax?.description, expectedSyntax.description)
    }

    func testNonConsecutivelySearchStringMatchingRanges() {
        //basic tests
        do {
            var matches: [Any]? = nil
            XCTAssertTrue("".nonConsecutivelySearch("", matchingRanges: &matches), "Equality of empty strings")
            XCTAssertTrue((matches?.count == 1) && NSEqualRanges(NSRange(location: 0, length: 0), RangeFromArray(matches, 0)), "Returned matches in empty string")
        }

        do {
            var matches = 0xdeadbeef
            XCTAssertFalse("".nonConsecutivelySearch("R", matchingRanges: &matches), "Inequality with empty left side")
            XCTAssertTrue((matches == 0xdeadbeef), "out variable not touched by mismatch")
        }

        XCTAssertFalse("L".nonConsecutivelySearch("", matchingRanges: nil), "Inequality with empty right side")

        do {
            var matches: [Any]? = nil
            XCTAssertTrue("left".nonConsecutivelySearch("le", matchingRanges: &matches), "Anchored match left")
            XCTAssertTrue((matches?.count == 1) && NSEqualRanges(NSRange(location: 0, length: 2), RangeFromArray(matches, 0)), "Returned matches in anchored left match")
        }

        do {
            var matches: [Any]? = nil
            XCTAssertTrue("right".nonConsecutivelySearch("ht", matchingRanges: &matches), "Anchored match right")
            XCTAssertTrue((matches?.count == 1) && NSEqualRanges(NSRange(location: 3, length: 2), RangeFromArray(matches, 0)), "Returned matches in anchroed right match")
        }

        XCTAssertFalse("ht".nonConsecutivelySearch("right", matchingRanges: nil), "Left and Right are not commutative")

        //real tests
        do {
            var matches: [Any]? = nil
            XCTAssertTrue("... is not secure anymore!".nonConsecutivelySearch("NSA", matchingRanges: &matches), "Non-consecutive match, ignoring case")
            XCTAssertTrue((matches?.count == 3) && NSEqualRanges(NSRange(location: 7, length: 1), RangeFromArray(matches, 0)) && NSEqualRanges(NSRange(location: 11, length: 1), RangeFromArray(matches, 1)) && NSEqualRanges(NSRange(location: 18, length: 1), RangeFromArray(matches, 2)), "Returned matches in non-consecutive string")
        }

        XCTAssertFalse("Deoxyribonucleic Acid".nonConsecutivelySearch("DNS", matchingRanges: nil), "Non-consecutive mismatch")

        do {
            var matches: [Any]? = nil
            XCTAssertTrue("Turn left, then right at the corner".nonConsecutivelySearch("left right", matchingRanges: &matches), "Partly consecutive match")
            XCTAssertTrue((matches?.count == 2) && (NSEqualRanges(NSRange(location: 5, length: 4), RangeFromArray(matches, 0))) && (NSEqualRanges(NSRange(location: 15, length: 6), RangeFromArray(matches, 1))), "Returned matches in partly-consecutive string")
        }

        //optimization tests
        do {
            var matches: [Any]? = nil
            //  Haystack:    "central_private_rabbit_park"
            //  Needle:      "centralpark"
            //  Unoptimized: "central_private_rabbit_park"
            //                ^^^^^^^ ^   ^   ^         ^ = 5 (after optimizing consecutive atomic matches)
            //  Desired:     "central_private_rabbit_park"
            //                ^^^^^^^                ^^^^ = 2
            XCTAssertTrue("central_private_rabbit_park".nonConsecutivelySearch("centralpark", matchingRanges: &matches), "Optimization partly consecutive match")
            XCTAssertTrue(((matches?.count == 2) && (NSEqualRanges(NSRange(location: 0, length: 7), RangeFromArray(matches, 0))) && (NSEqualRanges(NSRange(location: 23, length: 4), RangeFromArray(matches, 1)))), "Returned matches set is minimal")
        }
        do {
            // In the previous test it was always the end of the matches array that got optimized.
            // This time we'll have two different optimizations
            //   Needle:      ".abc123"
            //   Haystack:    "a.?a?ab?abc?1?12?123?"
            //   Unoptimized:   ^ ^  ^   ^ ^  ^   ^ = 7
            //   Desired:       ^      ^^^      ^^^ = 3
            var matches: [Any]? = nil
            XCTAssertTrue("a.?a?ab?abc?1?12?123?".nonConsecutivelySearch(".abc123", matchingRanges: &matches), "Optimization non-consecutive match")
            XCTAssertTrue(((matches?.count == 3) && (NSEqualRanges(NSRange(location: 1, length: 1), RangeFromArray(matches, 0))) && (NSEqualRanges(NSRange(location: 8, length: 3), RangeFromArray(matches, 1))) && (NSEqualRanges(NSRange(location: 17, length: 3), RangeFromArray(matches, 2)))), "Returned matches set is minimal (2)")
        }

        //advanced tests

        // LATIN CAPITAL LETTER A              == LATIN SMALL LETTER A
        // LATIN SMALL LETTER O WITH DIAERESIS == LATIN SMALL LETTER O
        // FULLWIDTH LATIN SMALL LETTER b      == LATIN SMALL LETTER B
        XCTAssertTrue("A:C3B6:EFBD82".nonConsecutivelySearch("aob", matchingRanges: nil), "Fuzzy matching of defined characters")

        //all bytes on the right are contained on the left, but on a character level "ä" is not contained in "Hütte Ф"
        XCTAssertFalse("HC3BCtte D0A4".nonConsecutivelySearch("C3A4", matchingRanges: nil), "Mismatch of composed characters with same prefix")

        // ":::" vs "" (according to wikipedia "" is the arachic variant of "印")
        // TECHNICALLY THIS SHOULD NOT MATCH!
        // However Apple doesn't correctly handle characters in the 4-Byte UTF range, so let's use this test to check for changes in Apples behaviour :)
        XCTAssertTrue(":F09F9884:F0A09884:".nonConsecutivelySearch("F09F9884", matchingRanges: nil), "Mismatch of composed characters (4-byte) with same prefix")

    }

    func testStringByReplacingCharactersInSetWithString() {
        do {
            //test against empty string
            XCTAssertEqual("".stringByReplacingCharacters(in: CharacterSet.whitespaces, with: "x"), "")
        }
        do {
            //test match at begin, middle, end / consecutive matches
            XCTAssertEqual(" ab  c ".stringByReplacingCharacters(in: CharacterSet.whitespaces, with: "_"), "_ab__c_")
        }
        do {
            //test replacement of different characters
            XCTAssertEqual("ab\r\ncd".stringByReplacingCharacters(in: CharacterSet.newlines, with: "*"), "ab**cd")
        }
        do {
            // nil for replacement char
            XCTAssertEqual("ab\r\ncd".stringByReplacingCharacters(in: CharacterSet.newlines, with: nil), "abcd")
        }
    }

    /**
     * stringByRemovingCharactersInSet test case.
     */
    /**
     * stringWithNewUUID test case.
     */
    /**
     * createViewSyntaxPrettifier test case.
     */
}

func RangeFromArray(a: [Any]?, idx: Int) -> NSRange {
    return ((a?[idx] as? NSValue)?.rangeValue)!
}
 */
}
