//
//  CalendarRepresentable.swift
//  ToDo App
//
//  Created by Егор Колобаев on 05.07.2024.
//

import Foundation
import SwiftUI

struct CalendarRepresentable: UIViewControllerRepresentable {
    var model: Todos
    func makeUIViewController(context: Context) -> UINavigationController {
        return UINavigationController(rootViewController: CalendarView(model: model))
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        if let calendar = uiViewController.viewControllers.first as? CalendarView {
            calendar.model = model
        }
    }
}
