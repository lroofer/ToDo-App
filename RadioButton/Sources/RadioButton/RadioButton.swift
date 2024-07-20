// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

@available(iOS 15.0, *)
public struct RadioButtonView: View {
    public enum RadioButtonState {
        case done, overdue, basic
    }
    public let state: RadioButtonState
    public let darkTheme: Bool

    public init(state: RadioButtonState, darkTheme: Bool = false) {
        self.state = state
        self.darkTheme = darkTheme
    }
    public var body: some View {
        Circle()
            .fill(innerCicleColor)
            .overlay {
                ZStack {
                    if state == .done {
                        Image(systemName: "checkmark")
                            .foregroundColor(.white)
                    }
                    Circle()
                        .stroke(outlineColor, lineWidth: 1.5)
                }
            }
            .frame(width: 20, height: 20)
    }
}

@available(iOS 15.0, *)
public extension RadioButtonView {
    public var innerCicleColor: Color {
        switch state {
        case .basic:
            return .clear
        case .overdue:
            return .red.opacity(0.1)
        case .done:
            return .green
        }
    }
    public var outlineColor: Color {
        switch state {
        case .basic:
            return darkTheme ? .white.opacity(0.2) : .black.opacity(0.2)
        case .done:
            return .green
        case .overdue:
            return .red
        }
    }
}
