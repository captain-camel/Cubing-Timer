//
//  AppSettings.swift
//  Cubing Timer
//
//  Created by Cameron Delong on 7/4/22.
//

import SwiftUI

/// A property wrapper that returns all of the settings from the `Settings` class.
@propertyWrapper struct AppSettings: DynamicProperty {
    // MARK: Properties
    /// An observer to detect changes to the settings.
    @ObservedObject private var settingsObserver: PublisherObservableObject
    
    /// The global settings.
    var wrappedValue: Settings { Settings.shared }
    
    // MARK: Initializers
    init() {
        let publisher = Settings.shared
            .settingChangedSubject
            .map { _ in () }
            .eraseToAnyPublisher()
        settingsObserver = .init(publisher: publisher)
    }
}
