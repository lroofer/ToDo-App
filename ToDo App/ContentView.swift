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
    
    var body: some View {
        NavigationStack {
            List{
                Section(header: HStack {
                    Text("Completed - \(todos.countCompleted)")
                    Spacer()
                    Button(showCompleted ? "Hide" : "Show") {
                        showCompleted.toggle()
                    }
                }
                    .font(.callout)
                    .textCase(.none)
                ) {
                    ForEach(todos.items.sorted(by: { a, b in
                        a.value.createdTime > b.value.createdTime
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
                                Button {
                                    if !item.value.done {
                                        saveItem(newItem: item.value.getCompleted)
                                    }
                                } label: {
                                    RadioButtonView(state: .done)
                                }
                                .tint(.green)
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
                        }
                        
                    }
    
                    
                    Button("New") {
                        addNewShow.toggle()
                    }
                        .foregroundStyle(.secondary)
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
            .navigationDestination(for: String.self, destination: { id in
                if let unpack = todos.items[id] {
                    TodoItemView(unpack: unpack, onSave: saveItem) { id in
                        todos.removeItem(with: id)
                    }
                }
            })
            .navigationTitle("My tasks")
        }
        .sheet(isPresented: $addNewShow) {
            TodoItemView(onSave: saveItem, onDelete: {_ in})
        }
    }
    func saveItem(newItem: TodoItem) {
        todos.setItem(with: newItem.id, value: newItem)
    }
}

#Preview {
    ContentView()
}
