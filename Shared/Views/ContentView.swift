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
    
    @StateObject var hudManager = HUDManager()
    
    // MARK: Body
    var body: some View {
        NavigationView {
            InstanceList(instances: instances)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .overlay(
            VStack {
                ForEach(hudManager.huds, id: \.self) { hud in
                    HUD {
                        if let systemImage = hud.systemImage {
                            Label(hud.text, systemImage: systemImage)
                        } else {
                            Text(hud.text)
                        }
                    }
                    .transition(.move(edge: .top).combined(with: .opacity))
                }
                
                Spacer()
            }
                .animation(.easeInOut(duration: 0.4))
        )
        .environmentObject(hudManager)
    }
}
