//
//  Settings.swift
//  Cubing Timer
//
//  Created by Cameron Delong on 11/12/21.
//

import SwiftUI

/// A class to access all of the global settings of the app.
final class Settings: AppSettings {
    // MARK: Properties
    /// A singleton instance of `AppSettings`.
    static let shared = Settings()
    
    /// Whether to preform haptic feedback on user interaction.
    @Field var doHaptics = false
    /// The color of the background when the timer is running.
    @Field var runningColor = Color(red: 0.27, green: 0.95, blue: 0.65)
    /// The color of the background during inspection.
    @Field var inspectionColor: Color = .yellow
}
