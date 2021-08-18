//
//  InstanceRow.swift
//  Cubing Timer
//
//  Created by Cameron Delong on 8/7/21.
//

import SwiftUI

/// A row to be displayed in a `NavigationView`, with the name, puzzle, and one statistic about an instance
struct InstanceRow: View {
    // MARK: Properties
    /// The `Instance` described by the `InstanceRow`.
    @ObservedObject var instance: Instance
    
    // MARK: Body
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(instance.name)
                    .bold()
                    .lineLimit(1)
                Text(String(instance.puzzle))
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            .padding(.vertical, 4)
            
            Spacer()
            
            StatisticView($instance.primaryStatistic, popover: false)
        }
    }
}
