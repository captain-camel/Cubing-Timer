//
//  HUD.swift
//  HUD
//
//  Created by Cameron Delong on 9/2/21.
//

import SwiftUI

/// A small HUD that drops from the top of the screen.
struct HUD<Content: View>: View {
    // MARK: Properties
    /// The content of the HUD.
    @ViewBuilder let content: Content
    
    // MARK: Body
    var body: some View {
        content
            .padding(.horizontal, 12)
            .padding(16)
            .background(
                Capsule()
                    .foregroundColor(Color.white)
                    .shadow(color: Color(.black).opacity(0.16), radius: 12, x: 0, y: 5)
            )
    }
}
