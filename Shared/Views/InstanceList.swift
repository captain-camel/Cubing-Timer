//
//  InstanceList.swift
//  Cubing Timer
//
//  Created by Cameron Delong on 8/7/21.
//

import SwiftUI

/// A list of `Instance`s.
struct InstanceList: View {
    // MARK: Properties
    /// All of the `Instance`s to display.
    var instances: FetchedResults<Instance>
    
    /// Whether the sheet to add a new instance is displayed.
    @State private var showingAddInstanceSheet = false
    
    // MARK: Body
    var body: some View {
        List {
            ForEach(instances, id: \.self) { instance in
                NavigationLink(destination: InstanceView(instance: instance)) {
                    InstanceRow(instance)
                }
            }
            .onDelete(perform: InstanceStorage.delete)
            
            Section(header: Text("More")) {
                NavigationLink(destination: SettingsView()) {
                    Label("Settings", systemImage: "gear")
                }
                
                NavigationLink(destination: AlgorithmCategoryList()) {
                    Label("Algorithms", systemImage: "square.grid.3x3.fill")
                }
                
                NavigationLink(destination: Text("help")) {
                    Label("Help", systemImage: "questionmark")
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Instances")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingAddInstanceSheet = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            
            ToolbarItem(placement: .navigationBarLeading) {
                EditButton()
            }
        }
        .sheet(isPresented: $showingAddInstanceSheet) {
            AddInstanceSheet { name, puzzle, inspectionDuration in
                InstanceStorage.add(
                    name: name,
                    puzzle: puzzle,
                    inspectionDuration: inspectionDuration
                )
            }
        }
    }
}
