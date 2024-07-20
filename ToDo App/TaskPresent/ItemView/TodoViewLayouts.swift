//
//  TodoViewLayouts.swift
//  ToDo App
//
//  Created by Егор Колобаев on 29.06.2024.
//

import SwiftUI

struct TodoViewLayout<Content: View, Content2: View>: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @FocusState var focusState: Bool
    @Binding var hasCustomColor: Bool
    @Binding var color: Color
    let textField: Content?
    let controls: Content2?
    init(hasCustomColor: Binding<Bool>, color: Binding<Color>, focusState: FocusState<Bool>,
         @ViewBuilder textField: () -> Content, @ViewBuilder controls: () -> Content2) {
        self._focusState = focusState
        self._hasCustomColor = hasCustomColor
        self._color = color
        self.textField = textField()
        self.controls = controls()
    }
    var body: some View {
        if horizontalSizeClass == .compact {
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        textField
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
                controls
            }
        } else {
            HStack {
                HStack {
                    VStack(alignment: .leading) {
                        textField
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
                if !focusState {
                    VStack {
                        controls
                        Spacer()
                    }
                    .transition(.scale)
                }
            }
        }
    }
}
