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
    
    // MARK: Body
    var body: some View {
        InstanceList(instances: instances)
    }
}
