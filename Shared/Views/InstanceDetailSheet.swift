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
    
    /// The instance displayed.
    @ObservedObject var instance: Instance
    
    /// Which tab is selected.
    @State private var selectedTab = "Solves"

    let columns = [
        GridItem(.adaptive(minimum: 150))
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
                
                ScrollView {
                    LazyVGrid(columns: columns) {
                        ForEach(Statistic.defaultCases, id: \.self) { statistic in
                            StatisticCard(statistic, instance: instance)
                                .padding(5)
                        }
                    }
                    .padding(.horizontal)
                }
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
