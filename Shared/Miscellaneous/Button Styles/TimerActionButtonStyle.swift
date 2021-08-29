//
//  TimerActionButtonStyle.swift
//  Cubing Timer
//
//  Created by Cameron Delong on 8/7/21.
//

import SwiftUI

/// A  rounded rect with a light gray background
struct TimerActionButtonStyle: ButtonStyle {
    // MARK: Properties
    /// Whether the button enabled.
    @Environment(\.isEnabled) private var isEnabled: Bool
    
    /// Whether the button is active.
    var isActive: Bool

    // MARK: Body
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .lineLimit(1)
            .font(.system(size: 15))
            .padding(.vertical, 6)
            .frame(maxWidth: .infinity)
            .background(
                !isEnabled
                    ? Color(.systemGray6)
                    : (configuration.isPressed
                        ? Color(.systemGray2)
                        : (isActive
                            ? Color(.systemGray3)
                            : Color(.systemGray5)))
            )
            .foregroundColor(
                isEnabled
                    ? .primary
                    : .secondary
            )
            .clipShape(
                RoundedRectangle(cornerRadius: 7, style: .continuous)
            )
            .scaleEffect(
                configuration.isPressed
                    ? 0.95
                    : 1
            )
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}
