//
//  CalendarRepresentable.swift
//  ToDo App
//
//  Created by Егор Колобаев on 05.07.2024.
//

import Foundation
import SwiftUI

struct CalendarRepresentable: UIViewControllerRepresentable {
    @Binding var showTaskView: Bool
    var model: Todos
    func makeUIViewController(context: Context) -> UINavigationController {
        return UINavigationController(rootViewController: CalendarView(model: model, showTaskView: $showTaskView.wrappedValue))
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        if let calendar = uiViewController.viewControllers.first as? CalendarView {
            calendar.model = model
            showTaskView = calendar.showTaskView
        }
    }
}
