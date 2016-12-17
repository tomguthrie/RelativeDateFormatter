//
// RelativeDateFormatterTests.swift
//
// Copyright (c) 2016 Thomas Guthrie
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicee, and/or sell
// copies of the Software, and to permit perso to whom the Software is
// furnished to do so, subject to the following conditio:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portio of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

import XCTest

@testable
import RelativeDateFormatter

class RelativeDateFormatterTests: XCTestCase {
    var calendar: Calendar!
    var components: DateComponents!
    var now: Date!
    var usFormatter: RelativeDateFormatter!
    var gbFormatter: RelativeDateFormatter!
    var result: String!

    override func setUp() {
        super.setUp()

        calendar = Calendar(identifier: .gregorian)
        components = DateComponents()
        components.year = 2013
        components.month = 1
        components.day = 11
        now = calendar.date(from: components)!

        let usLocale = Locale(identifier: "en_US")
        var usCalendar = Calendar(identifier: .gregorian)
        usCalendar.locale = usLocale
        usFormatter = RelativeDateFormatter()
        usFormatter.locale = usLocale
        usFormatter.calendar = usCalendar

        let gbLocale = Locale(identifier: "en_GB")
        var gbCalendar = Calendar(identifier: .gregorian)
        gbCalendar.locale = gbLocale
        gbFormatter = RelativeDateFormatter()
        gbFormatter.locale = gbLocale
        gbFormatter.calendar = gbCalendar
    }

    func testDateIsSameDayReturnsTime() {
        let date = calendar.date(from: components)!
        result = usFormatter.string(from: date, relativeTo: now)
        XCTAssertEqual(result, "12:00 AM")

        result = gbFormatter.string(from: date, relativeTo: now)
        XCTAssertEqual(result, "00:00")
    }

    func testDateIsYesterdayReturnsYesterday() {
        components.day = 10

        let date = calendar.date(from: components)!
        result = usFormatter.string(from: date, relativeTo: now)
        XCTAssertEqual(result, "Yesterday")

        result = gbFormatter.string(from: date, relativeTo: now)
        XCTAssertEqual(result, "Yesterday")
    }

    func testDateIsSameWeekReturnsDayOfWeek() {
        components.day = 7

        let date = calendar.date(from: components)!
        result = usFormatter.string(from: date, relativeTo: now)
        XCTAssertEqual(result, "Monday")

        result = gbFormatter.string(from: date, relativeTo: now)
        XCTAssertEqual(result, "Monday")
    }

    func testDateIsSameWeekReturnsDayOfWeekWhileRespectingCalendar() {
        components.day = 6

        let date = calendar.date(from: components)!
        result = usFormatter.string(from: date, relativeTo: now)
        XCTAssertEqual(result, "Sunday")

        result = gbFormatter.string(from: date, relativeTo: now)
        XCTAssertEqual(result, "6 Jan")
    }

    func testDateIsSameYearReturnsDayAndMonth() {
        components.day = 1

        let date = calendar.date(from: components)!
        result = usFormatter.string(from: date, relativeTo: now)
        XCTAssertEqual(result, "Jan 1")

        result = gbFormatter.string(from: date, relativeTo: now)
        XCTAssertEqual(result, "1 Jan")
    }

    func testDateIsNotTheSameYearReturnsTheFullDate() {
        components.day = 0

        let date = calendar.date(from: components)!
        result = usFormatter.string(from: date, relativeTo: now)
        XCTAssertEqual(result, "12/31/12")

        result = gbFormatter.string(from: date, relativeTo: now)
        XCTAssertEqual(result, "31/12/2012")
    }
}
