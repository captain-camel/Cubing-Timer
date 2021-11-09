//
//  InstanceDetailSheet.swift
//  InstanceDetailSheet
//
//  Created by Cameron Delong on 9/28/21.
//

import SwiftUI

/// A tab view with a list of solves and various statistics.
struct InstanceDetailSheet: View {
    // MARK: Properties
    /// The presentation mode of the sheet.
    @Environment(\.presentationMode) var presentationMode
    
    /// The `Instance` displayed.
    @ObservedObject var instance: Instance
    
    /// Which tab is selected.
    @State private var selectedTab = "Solves"

    /// Columns of the `LazyVGrid`.
    let columns = [
        GridItem(.adaptive(minimum: 180))
    ]
    
    // MARK: Body
    var body: some View {
        NavigationView {
            TabView(selection: $selectedTab) {
                List(instance.solveArray, id: \.id) { solve in
                    SolveRow(solve)
                }
                .tabItem {
                    Label("Solves", systemImage: "list.dash")
                }
                .tag("Solves")
                
                InstanceStatisticView(instance)
                .tabItem {
                    Label("Statistics", systemImage: "chart.bar.xaxis")
                }
                .tag("Statistics")
            }
            .navigationTitle(selectedTab)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}
