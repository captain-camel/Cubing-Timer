//
//  ContentView.swift
//  Cubing Timer
//
//  Created by Cameron Delong on 8/9/21.
//

import SwiftUI

/// The main `View` of the app.
struct ContentView: View {
    // MARK: Properties
    /// All of the `Instance`s fetched from Core Data.
    @FetchRequest(
        entity: Instance.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Instance.order, ascending: true)
        ]
    ) var instances: FetchedResults<Instance>
    
    /// An object to handle showing app-wide notifications through HUDs.
    @StateObject var hudManager = HUDManager()
    
    /// An object to handle haptics.
    @StateObject var hapticManager = HapticManager()
    
    // MARK: Body
    var body: some View {
        NavigationView {
            InstanceList(instances: instances)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .overlay(
            VStack {
                ZStack {
                    ForEach(hudManager.huds, id: \.self) { hud in
                        HUD {
                            if let systemImage = hud.systemImage, let imageColor = hud.imageColor {
                                HStack {
                                    Image(systemName: systemImage)
                                        .foregroundColor(imageColor)
                                    Text(hud.text)
                                }
                            } else {
                                Text(hud.text)
                            }
                        }
                        .transition(.move(edge: .top).combined(with: .opacity))
                    }
                }
                
                Spacer()
            }
                .animation(.easeInOut(duration: 0.4))
        )
        .environmentObject(hudManager)
        .environmentObject(hapticManager)
    }
}
