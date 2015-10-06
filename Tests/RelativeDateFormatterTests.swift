//
//  RelativeDateFormatterTests.swift
//  RelativeDateFormatterTests
//
//  Created by Thomas Guthrie on 06/10/2015.
//  Copyright © 2015 Thomas Guthrie. All rights reserved.
//

import XCTest
@testable import RelativeDateFormatter

class RelativeDateFormatterTests: XCTestCase {
    var calendar: NSCalendar!
    var components: NSDateComponents!
    var fromDate: NSDate!
    var formatter: RelativeDateFormatter!
    var gbFormatter: RelativeDateFormatter!
    var result: String!

    override func setUp() {
        super.setUp()

        calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        components = NSDateComponents()
        components.year = 2013
        components.month = 1
        components.day = 8
        fromDate = calendar.dateFromComponents(components)!

        formatter = RelativeDateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "en_US")
        formatter.calendar = calendar

        gbFormatter = RelativeDateFormatter()
        gbFormatter.locale = NSLocale(localeIdentifier: "en_GB")
        gbFormatter.calendar = calendar
    }

    func testDateIsSameDayReturnsTime() {
        let date = calendar.dateFromComponents(components)!
        result = formatter.stringForDate(date, fromDate: fromDate)
        XCTAssertEqual(result, "12:00 AM")

        result = gbFormatter.stringForDate(date, fromDate: fromDate)
        XCTAssertEqual(result, "00:00")
    }

    func testDateIsYesterdayReturnsYesterday() {
        components.day = 7

        let date = calendar.dateFromComponents(components)!
        result = formatter.stringForDate(date, fromDate: fromDate)
        XCTAssertEqual(result, "Yesterday")

        result = gbFormatter.stringForDate(date, fromDate: fromDate)
        XCTAssertEqual(result, "Yesterday")
    }

    func testDateIsSameWeekReturnsDayOfWeek() {
        components.day = 2

        let date = calendar.dateFromComponents(components)!
        result = formatter.stringForDate(date, fromDate: fromDate)
        XCTAssertEqual(result, "Wednesday")

        result = gbFormatter.stringForDate(date, fromDate: fromDate)
        XCTAssertEqual(result, "Wednesday")
    }

    func testDateIsSameYearReturnsDayAndMonth() {
        components.day = 1

        let date = calendar.dateFromComponents(components)!
        result = formatter.stringForDate(date, fromDate: fromDate)
        XCTAssertEqual(result, "Jan 1")

        result = gbFormatter.stringForDate(date, fromDate: fromDate)
        XCTAssertEqual(result, "1 Jan")
    }

    func testDateIsNotTheSameYearReturnsTheFullDate() {
        components.day = 0

        let date = calendar.dateFromComponents(components)!
        result = formatter.stringForDate(date, fromDate: fromDate)
        XCTAssertEqual(result, "12/31/12")

        result = gbFormatter.stringForDate(date, fromDate: fromDate)
        XCTAssertEqual(result, "31/12/2012")
    }
}
