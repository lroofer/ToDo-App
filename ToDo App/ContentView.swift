//
//  ContentView.swift
//  ToDo App
//
//  Created by Егор Колобаев on 18.06.2024.
//

import SwiftUI

struct ContentView: View {
    @State var tasks: [TodoItemView]
    @State var addNewShow = false
    @State var showCompleted = false
    var body: some View {
        NavigationStack {
            List{
                Section(header: HStack {
                    Text("Completed - none")
                    Spacer()
                    Button(showCompleted ? "Hide" : "Show") {
                        showCompleted.toggle()
                    }
                }
                    .font(.callout)
                    .textCase(.none)
                ) {
                    ForEach(0..<tasks.count, id:\.self) { id in
                        if !tasks[id].attachedItem.done || showCompleted {
                            NavigationLink(value: id) {
                                HStack {
                                    Button(action: {
                                        
                                    }, label: {
                                        if tasks[id].attachedItem.done {
                                            Image(systemName: "circle.inset.filled")
                                        } else {
                                            Image(systemName: "circle")
                                        }
                                    })
                                    .buttonBorderShape(.roundedRectangle)
                                    .buttonStyle(.plain)
                                    VStack (alignment: .leading) {
                                        Text(tasks[id].attachedItem.text)
                                            .lineLimit(1)
                                            .font(.system(size: 17))
                                        if tasks[id].attachedItem.deadline != nil {
                                            HStack {
                                                Image(systemName: "calendar")
                                                Text(tasks[id].attachedItem.deadline!.formatted(date: .abbreviated, time: .omitted))
                                            }
                                            .font(.system(size: 13))
                                            .foregroundColor(.accentColor)
                                        }
                                    }
                                    .padding(5)
                                }
                            }
                        }
                    }
                }
            }
            .navigationDestination(for: Int.self, destination: { id in
                tasks[id]
            })
            .navigationTitle("My tasks")
        }
        .overlay(alignment: .bottom) {
            if (!addNewShow) {
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
        .sheet(isPresented: $addNewShow) {
            TodoItemView()
        }
    }
}

#Preview {
    ContentView(tasks: [TodoItemView(attachedItem: TodoItem(id: UUID().uuidString, text: "Test 1", importance: .important, deadline: .now.tommorow!, done: false, creationDate: .now, lastChangeDate: nil)), TodoItemView(), TodoItemView()])
}
