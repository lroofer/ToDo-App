//
//  CalendarRepresentable.swift
//  ToDo App
//
//  Created by Егор Колобаев on 05.07.2024.
//

import Foundation
import SwiftUI

class CurrentState: ObservableObject {
    @Published var needsAnUpdate: Bool = false
}

struct CalendarRepresentable: UIViewControllerRepresentable {
    @Binding var showTaskView: Bool
    @Binding var selectedTask: TodoItem?
    @ObservedObject var model: Todos
    @ObservedObject var changeState: CurrentState
    func makeUIViewController(context: Context) -> UINavigationController {
        return UINavigationController(rootViewController: CalendarView(model: model, updateState: { status, value in
            showTaskView = status
            selectedTask = value
        }))
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        if let calendar = uiViewController.viewControllers.first as? CalendarView {
            calendar.model = model
        }
    }
}
