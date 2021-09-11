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
    
    /// The instance currently displayed.
    @State private var selectedInstance: Instance?
    
    // MARK: Body
    var body: some View {
        List {
            ForEach(instances, id: \.self) { instance in
                NavigationLink(destination: InstanceView(instance: instance), tag: instance, selection: $selectedInstance) {
                    InstanceRow(instance: instance)
                        .contextMenu {
                            StatisticView(instance.primaryStatistic, instance: instance)
                            
                            Button {
                                selectedInstance = instance
                            } label: {
                                Label("Open", systemImage: "arrow.up.forward.app")
                            }
                            
                            Button {
                                InstanceStorage.delete(instance)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                }
            }
            .onDelete(perform: InstanceStorage.delete)
            
            Section(header: Text("More")) {
                NavigationLink(destination: SettingsView()) {
                    Label("Settings", systemImage: "gear")
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
            AddInstanceSheet { name, puzzle, notes, inspectionDuration in
                InstanceStorage.add(
                    name: name,
                    puzzle: puzzle,
                    notes: notes,
                    inspectionDuration: inspectionDuration
                )
            }
        }
    }
}
