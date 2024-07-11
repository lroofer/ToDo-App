//
//  TaskListView.swift
//  ToDo App
//
//  Created by Егор Колобаев on 29.06.2024.
//

import SwiftUI
import CocoaLumberjackSwift

struct TasksListView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @ObservedObject var todos: Todos
    @ObservedObject var state: CurrentState
    
    @Binding var addNewShow: Bool
    @Binding var showCalendarView: Bool
    @Binding var selectedTask: TodoItem?

    @State var showCompleted = false
    @State var preferImportance = false
    
    init(todos: Todos, state: CurrentState, addNewShow: Binding<Bool>, selectedTask: Binding<TodoItem?>, showCalendarView: Binding<Bool>) {
        self.todos = todos
        self._addNewShow = addNewShow
        self._selectedTask = selectedTask
        self._showCalendarView = showCalendarView
        self.state = state
    }
    
    func toggleNewView() {
        selectedTask = nil
        addNewShow = true
        DDLogDebug("Task view has been toggled")
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
                if showCalendarView {
                    CalendarRepresentable(showTaskView: $addNewShow, selectedTask: $selectedTask, model: todos, changeState: state)
                } else {
                    listView
                }
                VStack {
                    Spacer()
                    buttonOverlay
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button {
                        showCalendarView.toggle()
                        DDLogVerbose("Switching UI-Kit with SwiftUI")
                    } label : {
                        Image(systemName: showCalendarView ? "tray.fill" : "calendar")
                    }
                    Menu {
                        Button((showCompleted ? "Hide" : "Show") + " Completed") {
                            showCompleted.toggle()
                            DDLogDebug("Customized view: showCompleted \(showCompleted)")
                        }
                        if !showCalendarView {
                            Menu ("Sort by") {
                                Button("Most recent added") {
                                    preferImportance = false
                                    DDLogVerbose("Sort by most recent added")
                                }
                                Button("Most important") {
                                    preferImportance = true
                                    DDLogVerbose("Sort by most important")
                                }
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
    TasksListView(todos: Todos(), state: .init(), addNewShow: .constant(false), selectedTask: .constant(nil), showCalendarView: .constant(false))
}
