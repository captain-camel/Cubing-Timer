//
//  Settings.swift
//  Cubing Timer
//
//  Created by Cameron Delong on 9/7/21.
//

import Foundation

/// Stores the property in `UserDefaults`.
@propertyWrapper struct Storage<T: Codable> {
    // MARK: Properties
    /// The `UserDefaults` key of the property.
    private let key: String
    /// The default value of the property.
    private let defaultValue: T
    
    /// The value of the property.
    var wrappedValue: T {
        get {
            // Read value from UserDefaults
            guard let data = UserDefaults.standard.object(forKey: key) as? Data else {
                // Return defaultValue when no data in UserDefaults
                return defaultValue
            }
            
            // Convert data to the desire data type
            let value = try? JSONDecoder().decode(T.self, from: data)
            return value ?? defaultValue
        }
        set {
            // Convert newValue to data
            let data = try? JSONEncoder().encode(newValue)
            
            // Set value to UserDefaults
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    // MARK: Initializers
    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
}
