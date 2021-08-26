//
//  Device.swift
//  Cubing Timer
//
//  Created by Cameron Delong on 8/7/21.
//

import SwiftUI

/// The different types of device the app can run on
enum Device {
    // MARK: Cases
    /// Phone shaped devices, like iPhone and iPod Touch.
    case phone
    /// Bigger devices, like iPads.
    case pad
    /// Computers, including iMacs, Mac Pros, Mac Minis, and MacBooks.
    case mac
    
    // MARK: Initializers
    /// Creates an instance of `Device` based on the current device.
    init() {
        #if os(macOS)
        self.currentDevice = .mac
        #else
        if UIDevice.current.userInterfaceIdiom == .phone {
            self = .phone
        } else {
            self = .pad
        }
        #endif
    }
}
