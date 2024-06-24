//
//  ContentView.swift
//  ToDo App
//
//  Created by Егор Колобаев on 18.06.2024.
//

import SwiftUI

struct ContentView: View {
    @State private var showTask = false
    @State private var selectedView: TodoItemView? = nil
    @State var tasks: [TodoItemView]
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack (alignment: .leading) {
                    ForEach($tasks, id: \.attachedItem.id) { task in
                        HStack {
                            Button("Open") {
                                selectedView = task.wrappedValue
                                showTask.toggle()
                            }
                            Text("item: \(task.wrappedValue.attachedItem.id)")
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("My tasks")
            .sheet(isPresented: $showTask) {
                if selectedView != nil {
                    selectedView
                }
            }
        }
    }
}

#Preview {
    ContentView(tasks: [TodoItemView(attachedItem: TodoItem(id: UUID().uuidString, text: "Test 1", importance: .important, deadline: .now.tommorow!, done: false, creationDate: .now, lastChangeDate: nil)), TodoItemView(), TodoItemView()])
}
