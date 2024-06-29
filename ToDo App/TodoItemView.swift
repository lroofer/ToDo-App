//
//  TodoItemView.swift
//  ToDo App
//
//  Created by Егор Колобаев on 24.06.2024.
//

import SwiftUI

struct TodoItemView: View {
    @Environment(\.dismiss) var dismiss
    @State var hasDeadline: Bool
    @State var hasCustomColor: Bool
    @State var deadline: Date
    @State var text: String
    @State var completed: Bool
    @State var color: Color
    @State var showCalendar: Bool = false
    @State var showColorPicker: Bool = false
    @State var priority: TodoItem.PriorityChoices
    let redactedId: String
    let creationDate: Date
    private let onSave: (TodoItem)->Void
    private let onDelete: (String)->Void

    init(unpack: TodoItem, onSave: @escaping (TodoItem)->Void, onDelete: @escaping (String)->Void) {
        self.redactedId = unpack.id
        self.text = unpack.text
        self.color = unpack.color ?? .primary
        self.hasCustomColor = unpack.color != nil
        self.completed = unpack.done
        self.priority = unpack.importance
        self.hasDeadline = unpack.deadline != nil
        self.deadline = unpack.deadline ?? .now.tommorow!
        self.creationDate = unpack.createdTime
        self.onSave = onSave
        self.onDelete = onDelete
    }
    init(onSave: @escaping (TodoItem)->Void, onDelete: @escaping (String)->Void) {
        self.init(unpack: TodoItem(), onSave: onSave, onDelete: onDelete)
    }
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    HStack {
                        VStack (alignment: .leading) {
                            TextField("What do you have to get done?", text: $text, axis: .vertical)
                                .lineLimit(6...20)
                            //Spacer()
                        }
                        .frame(minHeight: 120, maxHeight: .infinity)
                        .padding()
                        .background()
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        if hasCustomColor {
                            color
                                .frame(width: 5)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                        }
                    }
                        
                    VStack {
                        HStack(spacing: 120) {
                            Text("Priority")
                            Picker("Choose priority", selection: $priority) {
                                Image(systemName: "arrow.down").tag(TodoItem.PriorityChoices.low)
                                Text("None").tag(TodoItem.PriorityChoices.basic)
                                Image(systemName: "exclamationmark.2")
                                    //.renderingMode(.template)
                                    //.foregroundStyle(.red, .blue)
                                    .tag(TodoItem.PriorityChoices.important)
                            }
                            .pickerStyle(.segmented)
                            .labelsHidden()
                        }
                        Divider()
                        HStack {
                            Toggle(isOn: $hasCustomColor.animation(.easeInOut)) {
                                Button {
                                    withAnimation {
                                        showColorPicker.toggle()
                                    }
                                } label: {
                                    VStack (alignment: .leading) {
                                        Text("Custom color")
                                        Text(hasCustomColor ? color.toHex() ?? "custom" : "(none)")
                                            .foregroundStyle(hasCustomColor ? color : .secondary)
                                    }
                                }
                                .foregroundStyle(.primary)
                            }
                        }
                        if showColorPicker, hasCustomColor {
                            ColorPicker("Select", selection: $color, supportsOpacity: true)
                                .pickerStyle(.wheel)
                        }
                        HStack {
                            Toggle(isOn: $hasDeadline.animation(.easeIn)) {
                                Button {
                                    withAnimation {
                                        showCalendar.toggle()
                                    }
                                } label: {
                                    VStack (alignment: .leading){
                                        Text("Due to")
                                        if hasDeadline {
                                            Text(deadline.formatted(date: .abbreviated, time: .omitted))
                                                .font(.caption)
                                                .foregroundStyle(.blue)
                                        }
                                    }
                                }
                                .foregroundStyle(.primary)
                            }
                        }
                        if hasDeadline, showCalendar {
                            Divider()
                            DatePicker("Choose time", selection: $deadline, in: Date.now..., displayedComponents: .date)
                                .datePickerStyle(.graphical)
                                //.transition(.asymmetric(insertion: .scale, removal: .opacity))
                                
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
                                onDelete(redactedId)
                                dismiss()
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
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Task")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        onSave(TodoItem(id: redactedId, text: text, importance: priority, deadline: hasDeadline ? deadline : nil, done: completed, color: hasCustomColor ? color : nil, creationDate: creationDate, lastChangeDate: .now))
                        dismiss()
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    TodoItemView(onSave: {_ in}, onDelete: {_ in})
}
