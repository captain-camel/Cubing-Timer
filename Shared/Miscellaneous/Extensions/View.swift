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
    /// Runs the provided closure when the device's orientation changes.
    /// - Parameters:
    ///   - action: The closure to run when the device's orientation changes. Has one parameter, a `UIInterfaceOrientation` determined by the device's current orientation.
    @ViewBuilder func onRotate(perform action: @escaping (UIInterfaceOrientation) -> Void) -> some View {
        self
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                guard let scene = UIApplication.shared.windows.first?.windowScene else { return }
                action(scene.interfaceOrientation)
            }
    }
}

extension View {
    /// Updates a `Binding` when the size of a view changes.
    @ViewBuilder func readSize(size: Binding<CGSize>) -> some View {
        self
            .background(SizeReader(size: size))
    }
}
