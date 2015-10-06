//
//  RelativeDateFormatter.swift
//  RelativeDateFormatter
//
//  Created by Thomas Guthrie on 06/10/2015.
//  Copyright © 2015 Thomas Guthrie. All rights reserved.
//

import Foundation

@objc(TFGRelativeDateFormatter)
public class RelativeDateFormatter: NSValueTransformer {
    public var calendar: NSCalendar

    public var locale: NSLocale {
        didSet { resetLocale() }
    }

    private let dateFormatter: NSDateFormatter
    private let timeFormatter: NSDateFormatter
    private let weekFormatter: NSDateFormatter
    private let monthFormatter: NSDateFormatter

    public convenience override init() {
        self.init(locale: NSLocale.currentLocale(), calendar: NSCalendar.currentCalendar())
    }

    public init(locale: NSLocale, calendar: NSCalendar) {
        self.dateFormatter = NSDateFormatter()
        self.dateFormatter.dateStyle = .ShortStyle
        self.timeFormatter = NSDateFormatter()
        self.timeFormatter.timeStyle = .ShortStyle
        self.weekFormatter = NSDateFormatter()
        self.weekFormatter.dateFormat = "EEEE"
        self.monthFormatter = NSDateFormatter()
        self.locale = locale
        self.calendar = calendar
        super.init()
        resetLocale()
    }

    private func resetLocale() {
        dateFormatter.locale = locale
        timeFormatter.locale = locale
        weekFormatter.locale = locale
        monthFormatter.dateFormat = NSDateFormatter.dateFormatFromTemplate("d MMM", options: 0, locale: locale)
    }

    public override class func transformedValueClass() -> AnyClass {
        return NSString.self
    }

    public override class func allowsReverseTransformation() -> Bool {
        return false
    }

    public override func transformedValue(value: AnyObject?) -> AnyObject? {
        guard let date = value as? NSDate else { return nil }
        return stringForDate(date)
    }

    public func stringForDate(date: NSDate) -> String {
        return stringForDate(date, fromDate: NSDate())
    }

    public func stringForDate(date: NSDate, fromDate: NSDate) -> String {
        var components = calendar.components([.Hour, .Minute, .Second], fromDate: fromDate)
        components.hour = -components.hour
        components.minute = -components.minute
        components.second = -components.second
        let today = calendar.dateByAddingComponents(components, toDate: fromDate, options: [])!
        if date.laterDate(today) == date {
            return timeFormatter.stringFromDate(date)
        }

        components = NSDateComponents()
        components.day = -1
        let yesterday = calendar.dateByAddingComponents(components, toDate: today, options: [])!
        if date.laterDate(yesterday) == date {
            return "Yesterday"
        }

        components.day = -6
        let lastWeek = calendar.dateByAddingComponents(components, toDate: today, options: [])!
        if date.laterDate(lastWeek) == date {
            return weekFormatter.stringFromDate(date)
        }

        components = calendar.components([.Month, .Day], fromDate: fromDate)
        components.month = 1 - components.month
        components.day = 1 - components.day
        let endOfYear = calendar.dateByAddingComponents(components, toDate: fromDate, options: [])!
        if date.laterDate(endOfYear) == date {
            return monthFormatter.stringFromDate(date)
        }

        return dateFormatter.stringFromDate(date)
    }
}
