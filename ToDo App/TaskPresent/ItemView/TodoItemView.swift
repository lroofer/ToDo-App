//
//  TodoItemView.swift
//  ToDo App
//
//  Created by Егор Колобаев on 24.06.2024.
//

import SwiftUI
import CocoaLumberjackSwift

struct TodoItemView: View {
    @Environment(\.dismiss) var dismiss
    @FocusState var isInputActive: Bool

    @State var redactedId: String = ""
    @State var hasDeadline: Bool = false
    @State var hasCustomColor: Bool = false
    @State var deadline: Date = .now
    @State var creationDate: Date = .now
    @State var text: String = ""
    @State var completed: Bool = false
    @State var color: Color = .white
    @State var showCalendar: Bool = false
    @State var showColorPicker: Bool = false
    @State var priority: TodoItem.PriorityChoices = .basic
    
    @Binding var showView: Bool
    @Binding var selectedTask: TodoItem?
    
    private let onSave: (TodoItem)->Void
    private let onDelete: (String)->Void

    init(showView: Binding<Bool>, selectedTask: Binding<TodoItem?>, onSave: @escaping (TodoItem)->Void, onDelete: @escaping (String)->Void) {
        let newItem = selectedTask.wrappedValue ?? TodoItem()
        redactedId = newItem.id
        text = newItem.text
        color = newItem.color ?? .blue
        hasCustomColor = newItem.color != nil
        completed = newItem.done
        priority = newItem.importance
        hasDeadline = newItem.deadline != nil
        deadline = newItem.deadline ?? .now.nextDay!
        _showView = showView
        _selectedTask = selectedTask
        self.creationDate = newItem.createdTime
        self.onSave = onSave
        self.onDelete = onDelete
        DDLogDebug("View of \(redactedId) has been initiated")
    }
    var body: some View {
        NavigationStack {
            ScrollView {
                TodoViewLayout(hasCustomColor: $hasCustomColor, color: $color, focusState: _isInputActive, textField: {
                    TextField("What do you have to get done?", text: $text, axis: .vertical)
                        .lineLimit(6...)
                        .focused($isInputActive)
                        .toolbar {
                            ToolbarItemGroup(placement: .keyboard) {
                                Spacer()
                                
                                Button("Done") {
                                    isInputActive = false
                                    DDLogDebug("Keyboard is hidden")
                                }
                            }
                        }
                }, controls: {
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
                                selectedTask = nil
                                showView = false
                                dismiss()
                            }
                            .foregroundColor(.red)
                            .frame(maxWidth: 350)
                        }
                    }
                    .frame(maxWidth: .infinity, minHeight: 20, maxHeight: .infinity)
                    .padding()
                    .background()
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                })
                
                .padding()
            }
            .background(.thickMaterial)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Task")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        onSave(TodoItem(id: redactedId, text: text, importance: priority, deadline: hasDeadline ? deadline : nil, done: completed, color: hasCustomColor ? color : nil, creationDate: creationDate, lastChangeDate: .now))
                        selectedTask = nil
                        showView = false
                        dismiss()
                    }
                    .disabled(text.isEmpty)
                }
                if ToDo_AppApp.idiom != .pad {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Cancel") {
                            dismiss()
                        }
                    }
                } else {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            showView = false
                            selectedTask = nil
                        } label: {
                            Image(systemName: "xmark")
                        }
                    }
                }
                
            }
            .onChange(of: selectedTask) { oldValue in
                let newItem = selectedTask ?? TodoItem()
                redactedId = newItem.id
                text = newItem.text
                color = newItem.color ?? .blue
                hasCustomColor = newItem.color != nil
                completed = newItem.done
                priority = newItem.importance
                hasDeadline = newItem.deadline != nil
                deadline = newItem.deadline ?? .now.nextDay!
                creationDate = newItem.createdTime
                DDLogDebug("The item\(redactedId) has been updated")
            }
            .scrollDismissesKeyboard(.interactively)
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    TodoItemView(showView: .constant(true), selectedTask: .constant(.init()), onSave: {_ in}, onDelete: {_ in})
}
