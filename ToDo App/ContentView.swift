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
    @State private var selectedTask: TodoItem?
    @State private var columnVisibility = NavigationSplitViewVisibility.all
    @StateObject var state = CurrentState()

    var body: some View {
        // MARK: Specs require split view only for iPad.
        if ToDoAppApp.idiom != .pad {
            TasksListView(todos: todos, state: state, addNewShow: $addNewShow,
                          selectedTask: $selectedTask, showCalendarView: $showCalendarView)
                .sheet(isPresented: $addNewShow) {
                    selectedTask = nil
                } content: {
                    if selectedTask != nil {
                        TodoItemView(showView: $addNewShow, selectedTask: $selectedTask, onSave: todos.saveItem) { id in
                            todos.removeItem(with: id)
                        }
                    } else {
                        TodoItemView(showView: $addNewShow,
                                     selectedTask: $selectedTask,
                                     onSave: todos.saveItem,
                                     onDelete: {_ in})
                    }
                }
        } else {
            NavigationSplitView(columnVisibility: $columnVisibility) {
                TasksListView(todos: todos, state: state, addNewShow: $addNewShow,
                              selectedTask: $selectedTask, showCalendarView: $showCalendarView)
            } detail: {
                if !addNewShow {
                    Text("None of the tasks are selected")
                } else {
                    if selectedTask != nil {
                        TodoItemView(showView: $addNewShow,
                                     selectedTask: $selectedTask,
                                     onSave: todos.saveItem,
                                     onDelete: todos.removeItem)
                    } else {
                        TodoItemView(showView: $addNewShow,
                                     selectedTask: $selectedTask,
                                     onSave: todos.saveItem,
                                     onDelete: todos.removeItem)
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
