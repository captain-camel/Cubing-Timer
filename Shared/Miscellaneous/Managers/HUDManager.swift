//
//  HUDManager.swift
//  Cubing Timer
//
//  Created by Cameron Delong on 11/8/21.
//

import Combine
import Foundation
import SwiftUI

/// A class that manages app-wide notifications in a `HUD`.
class HUDManager: ObservableObject {
    /// The HUDs that are currently displayed.
    @Published var huds: [HUD] = []
    
    /// Displays a HUD over the UI with text and a system image.
    func showHUD(text: String, systemImage: String, imageColor: Color = .primary, duration: Double = 2) {
        huds.append(HUD(text: text, systemImage: systemImage, imageColor: imageColor))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            self.huds.remove(at: self.huds.firstIndex(of: HUD(text: text, systemImage: systemImage)) ?? 0)
        }
    }
    
    /// Displays a HUD over the UI with text.
    func showHUD(text: String, duration: Double = 2) {
        huds.append(HUD(text: text, systemImage: nil, imageColor: nil))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            self.huds.remove(at: self.huds.firstIndex(of: HUD(text: text, systemImage: nil)) ?? 0)
        }
    }
    
    /// A `struct` to represent a currently displayed HUD.
    struct HUD: Equatable, Hashable {
        var text: String
        var systemImage: String?
        var imageColor: Color?
    }
}
