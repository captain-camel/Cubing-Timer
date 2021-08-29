//
//  SizeReader.swift
//  Cubing Timer
//
//  Created by Cameron Delong on 8/27/21.
//

import SwiftUI

/// A view with a binding to its own size.
struct SizeReader: View {
    // MARK: Properties
    /// The size of the view.
    @Binding var size: CGSize
    
    // MARK: Body
    var body: some View {
        GeometryReader { geometry in
            Color.clear
                .onAppear {
                    DispatchQueue.main.async {
                        size = geometry.size.rounded()
                    }
                }
                .onChange(of: geometry.size) { _ in
                    DispatchQueue.main.async {
                        size = geometry.size.rounded()
                    }
                }
        }
    }
}
