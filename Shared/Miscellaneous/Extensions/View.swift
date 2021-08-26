//
//  View.swift
//  Cubing Timer
//
//  Created by Cameron Delong on 8/3/21.
//

import SwiftUI

extension View {
    /// Applies the given transform if the given condition evaluates to `true`.
    /// - Parameters:
    ///   - condition: The condition to evaluate.
    ///   - transform: The transform to apply to the source `View`.
    /// - Returns: Either the original `View` or the modified `View` if the condition is `true`.
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

extension View {
    /// Applies the given transform if the current device is in the list provided.
    /// - Parameters:
    ///   - devices: The devices on which the transformation should be applied.
    ///   - transform: The transform to apply to the source `View`.
    /// - Returns: Either the original `View` or the modified `View` if the current device is listed in `devices`.
    @ViewBuilder func onDevice<Content: View>(_ devices: Device..., transform: (Self) -> Content) -> some View {
        if devices.contains(Device()) {
            transform(self)
        } else {
            self
        }
    }
}

extension View {
    /// Removes a view based on boolean value.
    /// - Parameters:
    ///   - removed: Set to `false` to show the view. Set to `true` remove the view.
    /// - Returns: Either the original `View` or the removed `View` if `removed`evaluates to `true`
    @ViewBuilder func isRemoved(_ removed: Bool) -> some View {
        if !removed {
            self
        }
    }
}

extension View {
    /// Runs the provided closure when the device's orientation changes.
    /// - Parameters:
    ///   - action: The closure to run when the device's orientaion changes. Has one parameter, a `UIInterfaceOrientation` determined by the device's current orientation.
    func onRotate(perform action: @escaping (UIInterfaceOrientation) -> Void) -> some View {
        self
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                guard let scene = UIApplication.shared.windows.first?.windowScene else { return }
                action(scene.interfaceOrientation)
            }
    }
}
