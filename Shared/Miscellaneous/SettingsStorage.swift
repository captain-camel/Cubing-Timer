//
//  SettingsStorage.swift
//  Cubing Timer
//
//  Created by Cameron Delong on 11/13/21.
//

import Combine
import SwiftUI

/// A class that stores settings in `UserDefaults`.
class SettingsStorage: PropertyNameable {
    // MARK: Properties
    /// Updates views when a change to a setting occurs. Sends `nil` if all settings changed.
    var settingChangedSubject = PassthroughSubject<AnyKeyPath?, Never>()
}

extension SettingsStorage {
    // MARK: Methods
    /// Restores the defaults values of all of the settings.
    func restoreDefaults() {
        let mirror = Mirror(reflecting: self)
        
        for child in mirror.children {
            if let setting = child.value as? DefaultRestorable {
                setting.restoreDefaultValue(enclosingInstance: self)
            }
        }
        
        settingChangedSubject.send(nil)
    }
}

/// A type which can be restore to a default value.
protocol DefaultRestorable {
    /// Restores the default value of the type.
    func restoreDefaultValue(enclosingInstance instance: SettingsStorage)
}

/// A property wrapper that stores its value in `UserDefaults`.
///
/// Should be used inside of a class that inherits from `SettingsStorage`.
@propertyWrapper class Parameter<T: Codable>: DefaultRestorable {
    // MARK: Properties
    /// The default value of the setting. Returned if no value has been set previously.
    let defaultValue: T
    
    /// Returns the value of the parameter.
    static subscript<Enclosing: SettingsStorage>(
        _enclosingInstance instance: Enclosing,
        wrapped wrappedKeyPath: ReferenceWritableKeyPath<Enclosing, T>,
        storage storageKeyPath: ReferenceWritableKeyPath<Enclosing, Parameter>
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
            
            instance.settingChangedSubject.send(wrappedKeyPath)
        }
    }
    
    /// Returns a `Binding` to the parameter.
    static subscript<Enclosing: SettingsStorage>(
        _enclosingInstance instance: Enclosing,
        projected wrappedKeyPath: ReferenceWritableKeyPath<Enclosing, Binding<T>>,
        storage storageKeyPath: ReferenceWritableKeyPath<Enclosing, Parameter>
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
                    
                    instance.settingChangedSubject.send(wrappedKeyPath)
                }
            )
        }
        @available(*, unavailable, message: "Can't set projected value of @Parameter")
        set { fatalError() }
    }
    
    @available(*, unavailable, message: "@Parameter can only be applied to properties of classes")
    var wrappedValue: T {
        get { fatalError() }
        set { fatalError() }
    }
    
    @available(*, unavailable, message: "@Parameter can only be applied to properties of classes")
    var projectedValue: Binding<T> {
        get { fatalError() }
        set { fatalError() }
    }
    
    // MARK: Initializers
    init(wrappedValue: T) {
        self.defaultValue = wrappedValue
    }
    
    // MARK: Methods
    /// Restores the default value of the parameter.
    func restoreDefaultValue(enclosingInstance: SettingsStorage) {
        let key = enclosingInstance.name(of: self)
        
        let data = try? JSONEncoder().encode(defaultValue)
        
        UserDefaults.standard.set(data, forKey: key)
    }
}

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

final class PublisherObservableObject: ObservableObject {
    var subscriber: AnyCancellable?
    
    init(publisher: AnyPublisher<Void, Never>) {
        subscriber = publisher.sink(receiveValue: { [weak self] _ in
            self?.objectWillChange.send()
        })
    }
}
