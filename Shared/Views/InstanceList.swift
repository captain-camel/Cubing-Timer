//
//  InstanceList.swift
//  Cubing Timer
//
//  Created by Cameron Delong on 8/7/21.
//

import SwiftUI

struct InstanceList: View {
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
        NavigationView {
            List {
                ForEach(instances, id: \.id) { instance in
                    NavigationLink(destination: InstanceView(instance: instance)) {
                        InstanceRow(instance: instance)
                    }
                }
                .onDelete(perform: InstanceStorage.delete)
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Instances")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        InstanceStorage.add(
                            name: "name",
                            puzzle: ._2x2,
                            primaryStatistic: Statistic(kind: .average, modifier: 5),
                            secondaryStatistic: Statistic(kind: .average, modifier: 12)
                        )
                    } label: {
                        Image(systemName: "plus")
                    }
                }

                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
            }
            
            if instances.isEmpty {
                Text("No Instances.\nPress the plus button to create one.")
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        InstanceList()
    }
}
