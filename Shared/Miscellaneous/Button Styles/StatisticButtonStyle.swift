//
//  StatisticButtonStyle.swift
//  Cubing Timer
//
//  Created by Cameron Delong on 8/7/21.
//

import SwiftUI

/// A button with a transparent background, gray when pressed.
struct StatisticButtonStyle: ButtonStyle {
    // MARK: Properties
    /// Whether the button is active.
    @Environment(\.isEnabled) private var isEnabled: Bool
    
    // MARK: Body
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(configuration.isPressed ? Color(.systemGray5) : .clear)
            .cornerRadius(5)
    }
}
