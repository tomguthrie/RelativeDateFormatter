//
// RelativeDateFormatter.swift
//
// Copyright (c) 2016 Thomas Guthrie
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

import Foundation

/// Instances of `RelativeDateFormatter` can be used to get a localized relative date string similar
/// to how iOS' Mail app displays dates.
open class RelativeDateFormatter: Formatter {
    open override func string(for obj: Any?) -> String? {
        guard let date = obj as? Date else { return nil }
        return string(from: date)
    }

    /// Returns a string representation of a given date relative to another date
    /// using the reciever's current settings.
    ///
    /// - parameter date: The date to format.
    /// - parameter relativeTo: The date the string should be relative to; 
    ///   defaults to the current date/time.
    open func string(from date: Date, relativeTo: Date = Date()) -> String? {
        var todayComponents = calendar.dateComponents([.hour, .minute, .second], from: relativeTo)
        todayComponents.hour = -todayComponents.hour!
        todayComponents.minute = -todayComponents.minute!
        todayComponents.second = -todayComponents.second!

        if let today = calendar.date(byAdding: todayComponents, to: relativeTo), date >= today {
            return timeFormatter.string(from: date)
        }

        var yesterdayComponents = todayComponents
        yesterdayComponents.day = -1

        if let yesterday = calendar.date(byAdding: yesterdayComponents, to: relativeTo), date >= yesterday {
            // FIXME: Localise
            return "Yesterday"
        }

        var beginningOfWeekComponents = DateComponents()
        beginningOfWeekComponents.day = -(calendar.dateComponents([.weekday], from: relativeTo).weekday! - calendar.firstWeekday)

        if let beginningOfWeek = calendar.date(byAdding: beginningOfWeekComponents, to: relativeTo), date >= beginningOfWeek {
            return weekFormatter.string(from: date)
        }

        var beginningOfYearComponents = calendar.dateComponents([.month, .day], from: relativeTo)
        beginningOfYearComponents.month = 1 - beginningOfYearComponents.month!
        beginningOfYearComponents.day = 1 - beginningOfYearComponents.day!

        if let beginningOfYear = calendar.date(byAdding: beginningOfYearComponents, to: relativeTo), date >= beginningOfYear {
            return monthFormatter.string(from: date)
        }

        return dateFormatter.string(from: date)
    }

    // MARK: Locale/Calendar

    open var locale: Locale! = .current {
        willSet {
            reset()
        }
    }

    open var calendar: Calendar! = .current {
        willSet {
            reset()
        }
    }

    // MARK: Formatters

    private func reset() {
        _storedDateFormatter = nil
        _storedTimeFormatter = nil
        _storedWeekFormatter = nil
        _storedMonthFormatter = nil
    }

    private var dateFormatter: DateFormatter {
        if let formatter = _storedDateFormatter {
            return formatter
        } else {
            let formatter = DateFormatter()
            formatter.locale = locale
            formatter.calendar = calendar
            formatter.dateStyle = .short
            _storedDateFormatter = formatter
            return formatter
        }
    }
    private var _storedDateFormatter: DateFormatter?

    private var timeFormatter: DateFormatter {
        if let formatter = _storedTimeFormatter {
            return formatter
        } else {
            let formatter = DateFormatter()
            formatter.locale = locale
            formatter.calendar = calendar
            formatter.timeStyle = .short
            _storedTimeFormatter = formatter
            return formatter
        }
    }
    private var _storedTimeFormatter: DateFormatter?

    private var weekFormatter: DateFormatter {
        if let formatter = _storedWeekFormatter {
            return formatter
        } else {
            let formatter = DateFormatter()
            formatter.locale = locale
            formatter.calendar = calendar
            formatter.dateFormat = "EEEE"
            _storedWeekFormatter = formatter
            return formatter
        }
    }
    private var _storedWeekFormatter: DateFormatter?

    private var monthFormatter: DateFormatter {
        if let formatter = _storedMonthFormatter {
            return formatter
        } else {
            let formatter = DateFormatter()
            formatter.locale = locale
            formatter.calendar = calendar
            formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "d MMM", options: 0, locale: locale)
            _storedMonthFormatter = formatter
            return formatter
        }
    }
    private var _storedMonthFormatter: DateFormatter?
}
