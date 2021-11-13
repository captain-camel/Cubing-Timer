//
//  Settings.swift
//  Cubing Timer
//
//  Created by Cameron Delong on 11/12/21.
//

import Combine
import Foundation
import SwiftUI

/// A class to access all of the global settings of the app.
class Settings: PropertyNameable, ObservableObject {
    /// Whether to preform haptic feedback on user interaction.
    @Setting var doHaptics = false
    /// The color of the background when the timer is running.
    @Setting var runningColor = Color(red: 0.27, green: 0.95, blue: 0.65)
    /// The color of the background during inspection.
    @Setting var inspectionColor: Color = .yellow
}

class Test: PropertyNameable, ObservableObject {
    @Setting var int = 1
}

/// A global setting stored in `UserDefaults`.
@propertyWrapper class Setting<T: Codable> {
    // MARK: Properties
    /// The default value of the setting to use if no value is present.
    private let defaultValue: T
    
    /// Returns the value of the setting.
    static subscript<EnclosingType: PropertyNameable & ObservableObject>(
        _enclosingInstance instance: EnclosingType,
        wrapped wrappedKeyPath: ReferenceWritableKeyPath<EnclosingType, T>,
        storage storageKeyPath: ReferenceWritableKeyPath<EnclosingType, Setting>
    ) -> T {
        get {
            let setting: AnyObject = instance[keyPath: storageKeyPath]
            let key = instance.name(of: setting)
            
            guard let data = UserDefaults.standard.object(forKey: key) as? Data else {
                return instance[keyPath: storageKeyPath].defaultValue
            }
            
            let value = try? JSONDecoder().decode(T.self, from: data)
            return value ?? instance[keyPath: storageKeyPath].defaultValue
        }
        set {
            let data = try? JSONEncoder().encode(newValue)
            
            let setting: AnyObject = instance[keyPath: storageKeyPath]
            let key = instance.name(of: setting)
            
            UserDefaults.standard.set(data, forKey: key)
            
            let publisher = instance.objectWillChange
            (publisher as? ObservableObjectPublisher)?.send()
        }
    }
    
    /// Returns a binding to the setting.
    public static subscript<EnclosingType: PropertyNameable & ObservableObject>(
        _enclosingInstance instance: EnclosingType,
        projected wrappedKeyPath: KeyPath<EnclosingType, Binding<T>>,
        storage storageKeyPath: KeyPath<EnclosingType, Setting>
    ) -> Binding<T> {
        get {
            Binding(
                get: {
                    let setting: AnyObject = instance[keyPath: storageKeyPath]
                    let key = instance.name(of: setting)
                    
                    guard let data = UserDefaults.standard.object(forKey: key) as? Data else {
                        return instance[keyPath: storageKeyPath].defaultValue
                    }
                    
                    let value = try? JSONDecoder().decode(T.self, from: data)
                    return value ?? instance[keyPath: storageKeyPath].defaultValue
                },
                set: { newValue in
                    let data = try? JSONEncoder().encode(newValue)
                    
                    let setting: AnyObject = instance[keyPath: storageKeyPath]
                    let key = instance.name(of: setting)
                    
                    UserDefaults.standard.set(data, forKey: key)
                    
                    let publisher = instance.objectWillChange
                    (publisher as? ObservableObjectPublisher)?.send()
                })
        }
        set {}
    }
    
    /// `wrappedValue` declaration to satisfy compiler. Should never be accessed.
    @available(*, unavailable, message: "@Setting can only be applied to properties of classes")
    var wrappedValue: T {
        get { fatalError() }
        set { fatalError() }
    }
    
    /// `projectedValue` declaration to satisfy compiler. Should ever be accessed.
    @available(*, unavailable, message: "@Setting can only be applied to properties of classes")
    var projectedValue: Binding<T> {
        get { fatalError() }
        set { fatalError() }
    }
    
    // MARK: Initializers
    init(wrappedValue: T) {
        self.defaultValue = wrappedValue
    }
}
