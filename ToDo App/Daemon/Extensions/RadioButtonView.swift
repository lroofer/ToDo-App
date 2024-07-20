//
//  RadioButtonView.swift
//  ToDo App
//
//  Created by Егор Колобаев on 28.06.2024.
//

import SwiftUI
import RadioButton

extension RadioButtonView {
    static func getStateFrom(task: TodoItem) -> RadioButtonState {
        if task.done {
            return .done
        }
        if let deadline = task.deadline, deadline.compare(.now) == .orderedAscending {
            return .overdue
        }
        return .basic
    }
    init(task: TodoItem, darkTheme: Bool = false) {
        self.init(state: RadioButtonView.getStateFrom(task: task), darkTheme: darkTheme)
    }
}
