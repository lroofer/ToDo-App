//
//  TaskCellView.swift
//  ToDo App
//
//  Created by Егор Колобаев on 09.07.2024.
//

import SwiftUI
import CocoaLumberjackSwift

struct TaskCellView: View {
    let item: TodoItem
    let darkScheme: Bool
    let saveItem: (TodoItem) -> Void
    let removeItem: (String) -> Void
    private var buttonControl: some View {
        Button {
            if !item.done {
                DDLogDebug("An attempt to complete item(\(item.id) with checking the radio button in")
                saveItem(item.getCompleted)
            }
        } label: {
            RadioButtonView(task: item, darkTheme: darkScheme)
        }
        .buttonBorderShape(.roundedRectangle)
        .buttonStyle(.plain)
    }
    private var cellText: some View {
        VStack(alignment: .leading) {
            Text(item.text)
                .lineLimit(1)
                .font(.system(size: 17))
                .strikethrough(item.done)
                .foregroundStyle(item.done ? .secondary : .primary)
            if item.deadline != nil, !item.done {
                HStack {
                    Image(systemName: "calendar")
                    Text(item.deadline!.formatted(date: .abbreviated, time: .omitted))
                }
                .font(.system(size: 13))
                .foregroundColor(.secondary)
            }
        }
        .padding(5)
    }
    var body: some View {
        HStack {
            buttonControl
            if item.importance != .basic {
                Image(systemName: item.importance == .important ? "exclamationmark.2" : "arrow.down")
                    .foregroundStyle(item.importance == .important ? .red : .primary)
            }
            cellText
            if item.color != nil {
                Spacer()
                Circle()
                    .fill(item.color ?? .red)
                    .frame(width: 20, height: 20)
            }
        }
        .swipeActions(edge: .leading, allowsFullSwipe: true) {
            if !item.done {
                Button {
                    if !item.done {
                        DDLogDebug("An attempt to complete item(\(item.id) with a leading swipe")
                        saveItem(item.getCompleted)
                    }
                } label: {
                    RadioButtonView(state: .done)
                }
                .tint(.green)
            }
        }
        .swipeActions(edge: .trailing) {
            Button(role: .destructive) {
                DDLogDebug("An attempt to remove item(\(item.id) with a trailing swipe")
                removeItem(item.id)
            } label: {
                Image(systemName: "trash.fill")
            }
            Menu {
                Text("Unique id: \(item.id)")
                Text("Created time: \(item.createdTime.formatted(date: .abbreviated, time: .omitted))")
            } label: {
                Image(systemName: "info.circle.fill")
            }
        }
    }
}

#Preview {
    TaskCellView(item: .init(), darkScheme: true, saveItem: {_ in}, removeItem: {_ in})
}
