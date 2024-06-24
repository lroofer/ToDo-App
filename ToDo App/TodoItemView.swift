//
//  TodoItemView.swift
//  ToDo App
//
//  Created by Егор Колобаев on 24.06.2024.
//

import SwiftUI

struct TodoItemView: View {
    @State var hasDeadline: Bool
    @State var deadline: Date
    @State var text: String
    @State var completed: Bool
    @State var priority: TodoItem.PriorityChoices
    var attachedItem: TodoItem
    init(attachedItem: TodoItem) {
        self.attachedItem = attachedItem
        self.text = attachedItem.text
        self.completed = attachedItem.done
        self.priority = attachedItem.importance
        self.hasDeadline = attachedItem.deadline != nil
        self.deadline = attachedItem.deadline ?? .now.tommorow!
    }
    init() {
        self.init(attachedItem: TodoItem())
    }
    var body: some View {
        ScrollView {
            VStack {
                VStack (alignment: .leading) {
                    TextField("What do you have to get done?", text: $text, axis: .vertical)
                    Spacer()
                }
                .frame(minHeight: 120, maxHeight: .infinity)
                .padding()
                .background()
                .clipShape(RoundedRectangle(cornerRadius: 16))

                    
                VStack {
                    HStack(spacing: 120) {
                        Text("Priority")
                        Picker("Choose priority", selection: $priority) {
                            Image(systemName: "arrow.down").tag(TodoItem.PriorityChoices.low)
                            Text("None").tag(TodoItem.PriorityChoices.basic)
                            Image(systemName: "exclamationmark.2")
                                .tag(TodoItem.PriorityChoices.important)
                        }
                        .pickerStyle(.segmented)
                        .labelsHidden()
                    }
                    Divider()
                    
                    HStack {
                        Toggle(isOn: $hasDeadline) {
                            VStack (alignment: .leading){
                                Text("Due to")
                                if hasDeadline {
                                    Text( deadline.formatted(date: .abbreviated, time: .omitted))
                                        .font(.caption)
                                        .foregroundStyle(.blue)
                                }
                            }
                        }
                    }
                    if hasDeadline {
                        Divider()
                        DatePicker("Choose time", selection: $deadline, in: Date.now..., displayedComponents: .date)
                            .datePickerStyle(.graphical)
                    }
                    Spacer()
                }
                .frame(maxHeight: .infinity)
                .padding()
                .background()
                .clipShape(RoundedRectangle(cornerRadius: 16))
                VStack {
                    HStack {
                        Button("Delete") {
                            
                        }
                        .foregroundColor(.red)
                    }
                }
                .frame(maxWidth: .infinity, minHeight: 20, maxHeight: .infinity)
                .padding()
                .background()
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding()
        }
        .background(.thickMaterial)
    }
}

#Preview {
    TodoItemView()
}
