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
    
    // MARK: Body
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
        .onChange(of: scenePhase) { _ in
            PersistenceController.save()
        }
    }
}
