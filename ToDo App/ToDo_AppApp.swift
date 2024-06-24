//
//  ToDo_AppApp.swift
//  ToDo App
//
//  Created by Егор Колобаев on 18.06.2024.
//

import SwiftUI

@main
struct ToDo_AppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(tasks: [TodoItemView(attachedItem: TodoItem(id: UUID().uuidString, text: "Test 1", importance: .important, deadline: .now.tommorow!, done: false, creationDate: .now, lastChangeDate: nil)), TodoItemView(), TodoItemView()])
        }
    }
}
