//
//  Setting.swift
//  Cubing Timer
//
//  Created by Cameron Delong on 7/4/22.
//

import SwiftUI

/// Gets the value of a single setting from `Settings`.
@propertyWrapper struct Setting<T>: DynamicProperty {
    // MARK: Properties
    /// An observer to detect changes to the settings.
    @ObservedObject private var settingsObserver: PublisherObservableObject
    /// The key path to the observed setting.
    private let keyPath: ReferenceWritableKeyPath<Settings, T>
    
    // MARK: Initializers
    init(_ keyPath: ReferenceWritableKeyPath<Settings, T>) {
        self.keyPath = keyPath
        
        let publisher = Settings.shared
            .settingChangedSubject
            .filter { changedKeyPath in
                changedKeyPath == keyPath || changedKeyPath == nil
            }.map { _ in () }
            .eraseToAnyPublisher()
        self.settingsObserver = .init(publisher: publisher)
    }
    
    /// The value of the setting.
    var wrappedValue: T {
        get { Settings.shared[keyPath: keyPath] }
        nonmutating set { Settings.shared[keyPath: keyPath] = newValue }
    }
    
    /// A binding to the setting.
    var projectedValue: Binding<T> {
        Binding(
            get: { wrappedValue },
            set: { newValue in wrappedValue = newValue }
        )
    }
}
