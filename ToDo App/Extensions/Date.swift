//
//  Data.swift
//  ToDo App
//
//  Created by Егор Колобаев on 24.06.2024.
//

import Foundation

extension Date {
    var tommorow: Date? {
        return Calendar.current.date(byAdding: .day, value: 1, to: self)
    }
}
