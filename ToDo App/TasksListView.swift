//
//  TaskListView.swift
//  ToDo App
//
//  Created by Егор Колобаев on 29.06.2024.
//

import SwiftUI

struct TasksListView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var todos: Todos
    @Binding var addNewShow: Bool
    @Binding var showCalendarView: Bool
    @State var showCompleted = false
    @State var preferImportance = false
    @Binding var selectedTask: String?
    
    init(todos: Todos, addNewShow: Binding<Bool>, selectedTask: Binding<String?>, showCalendarView: Binding<Bool>) {
        self.todos = todos
        self._addNewShow = addNewShow
        self._selectedTask = selectedTask
        self._showCalendarView = showCalendarView
    }
    
    func toggleNewView() {
        selectedTask = nil
        addNewShow = true
    }
    
    private var buttonOverlay: some View {
        Button (action: toggleNewView) {
            Image(systemName: "plus.circle.fill")
                .resizable()
                .frame(width: 44, height: 44)
                .foregroundStyle(.blue)
                .shadow(color: .blue.opacity(0.3), radius: 20)
                .padding(.bottom, 5)
        }
    }
    
    private var listView: some View {
        List(selection: $selectedTask) {
            Section(header: HStack {
                Text("Completed - \(todos.countCompleted)")
            }
                .font(.callout)
                .textCase(.none)
            ) {
                ForEach(todos.getSorted(by: $preferImportance.wrappedValue), id: \.value) { item in
                    if !item.value.done || showCompleted {
                        NavigationLink(value: item.key) {
                            TaskCellView(item: item.value, darkScheme: colorScheme == .dark, saveItem: todos.saveItem, removeItem: todos.removeItem)
                                .onChange(of: selectedTask) { value in
                                    if value != nil {
                                        addNewShow = true
                                    }
                                }
                        }
                    }
                }
                Button("New") {
                    toggleNewView()
                }
                .foregroundStyle(.secondary)
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                listView
                VStack {
                    Spacer()
                    buttonOverlay
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button {
                        showCalendarView = true
                    } label : {
                        Image(systemName: "calendar")
                    }
                    Menu {
                        Button((showCompleted ? "Hide" : "Show") + " Completed") {
                            showCompleted.toggle()
                        }
                        Menu ("Sort by") {
                            Button("Most recent added") {
                                preferImportance = false
                            }
                            Button("Most important") {
                                preferImportance = true
                            }
                        }
                    } label: {
                        Label("Choose category", systemImage: "line.3.horizontal.decrease.circle")
                    }
                }
            }
            .navigationTitle("My tasks")
        }
    }
}

#Preview {
    TasksListView(todos: Todos(), addNewShow: .constant(false), selectedTask: .constant(nil), showCalendarView: .constant(false))
}
