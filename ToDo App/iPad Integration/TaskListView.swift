//
//  TaskListView.swift
//  ToDo App
//
//  Created by Егор Колобаев on 29.06.2024.
//

import SwiftUI

struct TaskListView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var todos: Todos
    @Binding var addNewShow: Bool
    @State var showCompleted = false
    @State var preferImportance = false
    @Binding var selectedTask: String?
    let saveItem: (TodoItem) -> Void
    
    init(todos: Todos, addNewShow: Binding<Bool>, selectedTask: Binding<String?>, saveItem: @escaping (TodoItem) -> Void) {
        self.todos = todos
        self._addNewShow = addNewShow
        self._selectedTask = selectedTask
        self.saveItem = saveItem
    }
    
    var body: some View {
        List(selection: $selectedTask){
            Section(header: HStack {
                Text("Completed - \(todos.countCompleted)")
                Spacer()
            }
                .font(.callout)
                .textCase(.none)
            ) {
                ForEach(todos.items.sorted(by: { a, b in
                    if preferImportance && a.value.importance != b.value.importance {
                        return a.value.importance == .important || (a.value.importance == .basic && b.value.importance == .low)
                    }
                    return a.value.createdTime > b.value.createdTime
                }), id: \.value) { item in
                    if !item.value.done || showCompleted {
                        NavigationLink(value: item.key) {
                            HStack {
                                Button(action: {
                                    if !item.value.done {
                                        saveItem(item.value.getCompleted)
                                    }
                                }, label: {
                                    RadioButtonView(task: item.value, darkTheme: colorScheme == .dark)
                                })
                                .buttonBorderShape(.roundedRectangle)
                                .buttonStyle(.plain)
                                if item.value.importance != .basic {
                                    Image(systemName: item.value.importance == .important ? "exclamationmark.2" : "arrow.down")
                                        .foregroundStyle(item.value.importance == .important ? .red : .primary)
                                }
                                VStack (alignment: .leading) {
                                    Text(item.value.text)
                                        .lineLimit(1)
                                        .font(.system(size: 17))
                                        .strikethrough(item.value.done)
                                        .foregroundStyle(item.value.done ? .secondary : .primary)
                                    if item.value.deadline != nil, !item.value.done {
                                        HStack {
                                            Image(systemName: "calendar")
                                            Text(item.value.deadline!.formatted(date: .abbreviated, time: .omitted))
                                        }
                                        .font(.system(size: 13))
                                        .foregroundColor(.secondary)
                                    }
                                }
                                .padding(5)
                                if item.value.color != nil {
                                    Spacer()
                                    Circle()
                                        .fill(item.value.color ?? .red)
                                        .frame(width: 20, height: 20)
                                }
                            }
                        }
                        .swipeActions(edge: .leading, allowsFullSwipe: false) {
                            if !item.value.done{
                                Button {
                                    if !item.value.done {
                                        saveItem(item.value.getCompleted)
                                    }
                                } label: {
                                    RadioButtonView(state: .done)
                                }
                                .tint(.green)
                            }
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button (role: .destructive) {
                                todos.removeItem(with: item.key)
                            } label: {
                                Image(systemName: "trash.fill")
                            }
                            Button {
                                
                            } label: {
                                Image(systemName: "info.circle.fill")
                            }
                        }
                        .onChange(of: selectedTask, perform: { value in
                            if value != nil {
                                addNewShow = true
                            }
                        })
                    }
                    
                }
                
                
                Button("New") {
                    selectedTask = nil
                    addNewShow.toggle()
                }
                .foregroundStyle(.secondary)
            }
            
        }
        .overlay(alignment: .bottom) {
            Button("+") {
                selectedTask = nil
                addNewShow.toggle()
            }
            .frame(width: 44, height: 44)
            .font(.largeTitle)
            .foregroundStyle(.white)
            .background(.blue)
            .clipShape(Circle())
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button((showCompleted ? "Hide" : "Show") + " Completed") {
                        showCompleted.toggle()
                    }
                    Menu("Sort by") {
                        Button("Most Recent") {
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
    }
    
}

#Preview {
    TaskListView(todos: Todos(), addNewShow: .constant(false), selectedTask: .constant(nil), saveItem: {_ in})
}
