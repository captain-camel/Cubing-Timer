//
//  Device.swift
//  Cubing Timer
//
//  Created by Cameron Delong on 8/7/21.
//

import SwiftUI

class Device {
    // MARK: Properties
    /// A singleton instance of `DeviceInfo`, containing informationg about the device the app is running on.
    static let shared = Device()
    
    /// The type of device the app is running on.
    var currentDevice: Kind
    
    // MARK: Initializers
    /// Creates an instance of `Device`, and sets `currentDevice` to the correct `Kind`.
    init() {
        #if os(macOS)
        self.currentDevice = .mac
        #else
        if UIDevice.current.userInterfaceIdiom == .phone {
            self.currentDevice = .phone
        } else {
            self.currentDevice = .pad
        }
        #endif
    }
    
    // MARK: Types
    /// The different types of device the app can run on
    enum Kind {
        /// Phone shaped devices, like iPhone and iPod Touch
        case phone
        /// Bigger devices, like iPads
        case pad
        /// Computers, including iMacs, Mac Pros, Mac Minis, and MacBooks
        case mac
    }
}
