//
//  Cubing_TimerApp.swift
//  Shared
//
//  Created by Cameron Delong on 8/7/21.
//

import SwiftUI

@main
struct Cubing_TimerApp: App {
    // MARK: Properties
    // The current phase of the scene.
    @Environment(\.scenePhase) private var scenePhase
    
    /// The singleton instance of `PersistenceController`.
    let persistenceController = PersistenceController.shared
    
    /// An object to manage global app settings.
    @StateObject var settings = Settings.shared
    
    /// An object to handle haptics.
    @StateObject var hapticManager = HapticManager()
    
    /// An object to handle showing app-wide notifications through HUDs.
    @StateObject var hudManager = HUDManager()
    
    // MARK: Body
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(settings)
                .environmentObject(hapticManager)
                .environmentObject(hudManager)
        }
        .onChange(of: scenePhase) { _ in
            PersistenceController.save()
        }
    }
}
