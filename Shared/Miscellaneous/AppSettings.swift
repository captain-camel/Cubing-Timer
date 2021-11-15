//
//  AppSettings.swift
//  Cubing Timer
//
//  Created by Cameron Delong on 11/13/21.
//

import Foundation
import Combine
import SwiftUI

/// A type which can be restore to a default value.
protocol DefaultRestorable {
    /// Restores the default value of the type.
    func restoreDefaultValue()
}

/// A class that stores settings in `UserDefaults`.
protocol AppSettings: PropertyNameable & ObservableObject {}

extension AppSettings {
    // MARK: Methods
    /// Restores the defaults values of all of the settings.
    func restoreDefaults() {
        let mirror = Mirror(reflecting: self)
        
        for child in mirror.children {
            let setting = child.value as? DefaultRestorable
            setting?.restoreDefaultValue()
        }
        
        let publisher = objectWillChange
        (publisher as? ObservableObjectPublisher)?.send()
    }
}

/// A global setting stored in `UserDefaults`.
@propertyWrapper class Field<T: Codable>: DefaultRestorable {
    // MARK: Properties
    /// The default value of the setting to use if no value is present.
    private let defaultValue: T
    
    /// The key at which this setting is stored in `UserDefaults`.
    private var key: String?
    
    /// Returns the value of the setting.
    static subscript<EnclosingType: AppSettings>(
        _enclosingInstance instance: EnclosingType,
        wrapped wrappedKeyPath: ReferenceWritableKeyPath<EnclosingType, T>,
        storage storageKeyPath: ReferenceWritableKeyPath<EnclosingType, Field>
    ) -> T {
        get {
            let setting: AnyObject = instance[keyPath: storageKeyPath]
            let key = instance.name(of: setting)
            instance[keyPath: storageKeyPath].key = key
            
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
            instance[keyPath: storageKeyPath].key = key
            
            UserDefaults.standard.set(data, forKey: key)
            
            let publisher = instance.objectWillChange
            (publisher as? ObservableObjectPublisher)?.send()
        }
    }
    
    /// Returns a binding to the setting.
    static subscript<EnclosingType: AppSettings>(
        _enclosingInstance instance: EnclosingType,
        projected wrappedKeyPath: KeyPath<EnclosingType, Binding<T>>,
        storage storageKeyPath: KeyPath<EnclosingType, Field>
    ) -> Binding<T> {
        get {
            Binding(
                get: {
                    let setting: AnyObject = instance[keyPath: storageKeyPath]
                    let key = instance.name(of: setting)
                    instance[keyPath: storageKeyPath].key = key
                    
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
                    instance[keyPath: storageKeyPath].key = key
                    
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
        self.key = nil
    }
    
    // MARK: Methods
    /// Restores the default value of this setting.
    func restoreDefaultValue() {
        let data = try? JSONEncoder().encode(defaultValue)
        
        if let key = key {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}
