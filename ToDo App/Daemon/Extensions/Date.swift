//
//  Data.swift
//  ToDo App
//
//  Created by Егор Колобаев on 24.06.2024.
//

import Foundation

extension Date {
    var nextDay: Date? {
        return Calendar.current.date(byAdding: .day, value: 1, to: self)
    }
    var components: Int {
        let day = Calendar.current.component(.day, from: self)
        let month = Calendar.current.component(.month, from: self)
        return month * 100 + day
    }
    static func getMonthName(from month: Int) -> String {
        switch month {
        case 1:
            return "Jan"
        case 2:
            return "Feb"
        case 3:
            return "Mar"
        case 4:
            return "Apr"
        case 5:
            return "May"
        case 6:
            return "June"
        case 7:
            return "July"
        case 8:
            return "Aug"
        case 9:
            return "Sep"
        case 10:
            return "Oct"
        case 11:
            return "Nov"
        case 12:
            return "Dec"
        default:
            return "Unknown"
        }
    }
    static func getRepresentation(from components: Int) -> String {
        let month = components / 100
        let day = components % 100
        return "\(day) \(getMonthName(from: month))"
    }
}
