//
//  Settings.swift
//  Cubing Timer
//
//  Created by Cameron Delong on 11/12/21.
//

import SwiftUI

/// A class to access all of the global settings of the app.
final class Settings: SettingsStorage {
    // MARK: Properties
    /// A singleton instance of `AppSettings`.
    static let shared = Settings()
    
    /// Whether to preform haptic feedback on user interaction.
    @Parameter("doHaptics") var doHaptics = true
    /// The color of the background when the timer is running.
    @Parameter("runningColor") var runningColor = Color(red: 0.27, green: 0.95, blue: 0.65)
    /// The color of the background during inspection.
    @Parameter("inspectionColor") var inspectionColor: Color = .yellow
}
