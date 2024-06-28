//
//  RadioButtonView.swift
//  ToDo App
//
//  Created by Егор Колобаев on 28.06.2024.
//

import SwiftUI

struct RadioButtonView: View {
    enum RadioButtonState {
        case done, overdue, basic
    }
    private let state: RadioButtonState
    
    init(state: RadioButtonState) {
        self.state = state
    }
    
    var body: some View {
        Circle()
            .fill(innerCicleColor)
            .overlay {
                ZStack {
                    if state == .done {
                        Image(systemName: "checkmark")
                            .foregroundColor(.white)
                    }
                    Circle()
                        .stroke(outlineColor, lineWidth: 1.5)
                }
            }
            .frame(width: 20, height: 20)
    }
}

private extension RadioButtonView {
    var innerCicleColor: Color {
        switch state {
        case .basic:
            return .clear
        case .overdue:
            return .red.opacity(0.1)
        case .done:
            return .green
        }
    }
    var outlineColor: Color {
        switch state {
        case .basic:
            return .black.opacity(0.2)
        case .done:
            return .green
        case .overdue:
            return .red
        }
    }
}

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
    init(task: TodoItem) {
        self.state = RadioButtonView.getStateFrom(task: task)
    }
}

#Preview {
    RadioButtonView(state: .overdue)
}
