//
//  Settings.swift
//  Cubing Timer
//
//  Created by Cameron Delong on 11/12/21.
//

import SwiftUI

/// A class to access all of the global settings of the app.
class Settings: AppSettings {
    // MARK: Properties
    /// A singleton instance of `AppSettings`.
    static let shared = Settings()
    
    /// Whether to preform haptic feedback on user interaction.
    @Setting var doHaptics = false
    /// The color of the background when the timer is running.
    @Setting var runningColor = Color(red: 0.27, green: 0.95, blue: 0.65)
    /// The color of the background during inspection.
    @Setting var inspectionColor: Color = .yellow
    
    // MARK: Initializers
    private init() {}
}
