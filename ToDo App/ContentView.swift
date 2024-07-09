//
//  ContentView.swift
//  ToDo App
//
//  Created by Егор Колобаев on 18.06.2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject var todos = Todos()
    @State var addNewShow = false
    @State var showCalendarView = false
    @State private var selectedTask: String?
    @State private var columnVisibility = NavigationSplitViewVisibility.all
    
    var body: some View {
        // MARK: Specs require split view only for iPad.
        if ToDo_AppApp.idiom != .pad {
            TasksListView(todos: todos, addNewShow: $addNewShow, selectedTask: $selectedTask, showCalendarView: $showCalendarView)
                .sheet(isPresented: $addNewShow) {
                    selectedTask = nil
                } content: {
                    if let selectedTask, let unpack = todos.items[selectedTask] {
                        TodoItemView(unpack: unpack, showView: $addNewShow, onSave: todos.saveItem) { id in
                            todos.removeItem(with: id)
                        }
                    } else {
                        TodoItemView(showView: $addNewShow, onSave: todos.saveItem, onDelete: {_ in})
                    }
                }
        } else {
            NavigationSplitView (columnVisibility: $columnVisibility) {
                TasksListView(todos: todos, addNewShow: $addNewShow, selectedTask: $selectedTask, showCalendarView: $showCalendarView)
            } detail: {
                if !addNewShow {
                    Text("None of the tasks are selected")
                } else {
                    if selectedTask == nil {
                        TodoItemView(showView: $addNewShow, onSave: todos.saveItem, onDelete: todos.removeItem)
                    } else {
                        TodoItemView(unpack: todos.items[selectedTask!] ?? TodoItem(), showView: $addNewShow, onSave: todos.saveItem, onDelete: todos.removeItem)
                    }
                }
            }
            .navigationSplitViewStyle(.balanced)
        }
    }
    
}

#Preview {
    ContentView()
}
