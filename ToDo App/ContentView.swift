//
//  ContentView.swift
//  ToDo App
//
//  Created by Егор Колобаев on 18.06.2024.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject var todos = Todos()
    @State var addNewShow = false
    @State var showCompleted = false
    @State var preferImportance = false
    @State var showCalendarView = false
    @State private var selectedTask: String?
    
    var body: some View {
        NavigationStack {
            List(selection: $selectedTask){
                Section(header: HStack {
                    Text("Completed - \(todos.countCompleted)")
                    //Spacer()
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
                                            saveItem(newItem: item.value.getCompleted)
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
                                            saveItem(newItem: item.value.getCompleted)
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
                                Menu {
                                    Text("Unique id: \(item.key)")
                                    Text("Completed: \(item.value.done)")
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
                        addNewShow.toggle()
                    }
                    .foregroundStyle(.secondary)
                }
                
            }
            
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button(action: {
                        showCalendarView = true
                    }, label: {
                        Image(systemName: "calendar")
                    })
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
            .sheet(isPresented: $showCalendarView, content: {
                CalendarRepresentable(model: todos)
                    .overlay(alignment: .bottom) {
                        Button("+") {
                            addNewShow.toggle()
                        }
                        .frame(width: 44, height: 44)
                        .font(.largeTitle)
                        .foregroundStyle(.white)
                        .background(.blue)
                        .clipShape(Circle())
                    }
            })
            .navigationTitle("My tasks")
        }
        .sheet(isPresented: $addNewShow, onDismiss: {
            selectedTask = nil
        }) {
            if let selectedTask, let unpack = todos.items[selectedTask] {
                TodoItemView(unpack: unpack, onSave: saveItem) { id in
                    todos.removeItem(with: id)
                }
            } else {
                TodoItemView(onSave: saveItem, onDelete: {_ in})
            }
        }
        
        .overlay(alignment: .bottom) {
            Button("+") {
                addNewShow.toggle()
            }
            .frame(width: 44, height: 44)
            .font(.largeTitle)
            .foregroundStyle(.white)
            .background(.blue)
            .clipShape(Circle())
        }
    }
    func saveItem(newItem: TodoItem) {
        todos.setItem(with: newItem.id, value: newItem)
    }
}

#Preview {
    ContentView()
}
