//
//  InstanceStatisticView.swift
//  Cubing Timer
//
//  Created by Cameron Delong on 10/3/21.
//

import SwiftUI
import CoreCharts

/// A view containing statistics about an `Instance`.
struct InstanceStatisticView: View {
    // MARK: Properties
    /// The `Instance` displayed.
    @ObservedObject var instance: Instance
    
    /// Columns of the `LazyVGrid`.
    let columns = [
        GridItem(.adaptive(minimum: 170))
    ]
    
    // MARK: Initializers
    init(_ instance: Instance) {
        self.instance = instance
    }
    
    // MARK: Body
    var body: some View {
        ScrollView {
            LineChart(data: instance.solveArray.map(\.time))
                .padding()
            
            LazyVGrid(columns: columns) {
                ForEach(Statistic.defaultCases, id: \.self) { statistic in
                    StatisticCard(statistic, instance: instance)
                        .padding(5)
                        .frame(height: 100)
                }
            }
            .padding(.horizontal)
        }
    }
}
