//
//  SettingsStorage.swift
//  Cubing Timer
//
//  Created by Cameron Delong on 11/13/21.
//

import Combine
import SwiftUI

/// A class that stores settings in `UserDefaults`.
class SettingsStorage {
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
            if let setting = child.value as? SettingsStorageParameter {
                setting.restoreDefaultValue()
            }
        }
        
        settingChangedSubject.send(nil)
    }
}

/// A protocol corresponding to `SettingsStorage.Parameter`
protocol SettingsStorageParameter {
    /// Restores the default value of the type.
    func restoreDefaultValue()
}

extension SettingsStorage {
    /// A property wrapper that stores its value in `UserDefaults`.
    ///
    /// Should be used inside of a class that inherits from `SettingsStorage`.
    @propertyWrapper class Parameter<T: Codable>: SettingsStorageParameter {
        // MARK: Properties
        /// The default value of the setting. Returned if no value has been set previously.
        let defaultValue: T
        
        let key: String
        
        var wrappedValue: T {
            get {
                guard let data = UserDefaults.standard.object(forKey: key) as? Data else {
                    return defaultValue
                }
                
                let value = try? JSONDecoder().decode(T.self, from: data)
                return value ?? defaultValue
            }
            set {
                guard let data = try? JSONEncoder().encode(newValue) else {
                    return
                }
                
                UserDefaults.standard.set(data, forKey: key)
            }
        }
        
        var projectedValue: Binding<T> {
            Binding(
                get: {
                    guard let data = UserDefaults.standard.object(forKey: self.key) as? Data else {
                        return self.defaultValue
                    }
                    
                    let value = try? JSONDecoder().decode(T.self, from: data)
                    return value ?? self.defaultValue
                },
                set: { newValue in
                    guard let data = try? JSONEncoder().encode(newValue) else {
                        return
                    }
                    
                    UserDefaults.standard.set(data, forKey: self.key)
                }
            )
        }
        
        // MARK: Initializers
        init(wrappedValue: T, _ key: String) {
            self.defaultValue = wrappedValue
            self.key = key
        }
        
        // MARK: Methods
        /// Restores the default value of the parameter.
        func restoreDefaultValue() {
            guard let data = try? JSONEncoder().encode(defaultValue) else {
                return
            }
            
            UserDefaults.standard.set(data, forKey: key)
        }
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
