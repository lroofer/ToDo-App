//
//  SplitPadView.swift
//  ToDo App
//
//  Created by Егор Колобаев on 29.06.2024.
//

import SwiftUI

struct SplitPadView: View {
    @StateObject var todos = Todos()
    @State var addNewShow = false
    @State var selectedTask: String?
    @State private var columnVisibility = NavigationSplitViewVisibility.all

    func saveItem(newItem: TodoItem) {
        todos.setItem(with: newItem.id, value: newItem)
    }
    
    var body: some View {
        GeometryReader(content: { geometry in
            NavigationSplitView (columnVisibility: $columnVisibility) {
                TaskListView(todos: todos, addNewShow: $addNewShow, selectedTask: $selectedTask, saveItem: saveItem)
            } detail: {
                if selectedTask == nil && !addNewShow {
                    Text("None of the tasks are selected")
                } else {
                    
                    if selectedTask == nil {
                        TodoItemView(onSave: saveItem, onDelete: todos.removeItem)
                    } else {
                        TodoItemView(unpack: todos.items[selectedTask!] ?? TodoItem(), onSave: saveItem, onDelete: todos.removeItem)
                    }
                    
                }
            }
            .navigationSplitViewStyle(.balanced)
        })
    }
}

#Preview {
    SplitPadView()
}
