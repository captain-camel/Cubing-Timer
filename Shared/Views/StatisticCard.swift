//
//  StatisticCard.swift
//  StatisticCard
//
//  Created by Cameron Delong on 9/29/21.
//

import SwiftUI

/// A card displaying a `Statistic`.
struct StatisticCard: View {
    // MARK: Properties
    /// The `Statistic` described by the `StatisticCard`.
    var statistic: Statistic
    /// The `Instance` who's `Statistic` is displayed.
    @ObservedObject var instance: Instance
    
    // MARK: Initializers
    init(_ statistic: Statistic, instance: Instance) {
        self.statistic = statistic
        self.instance = instance
    }
    
    // MARK: Body
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color(.systemBackground))
                .shadow(radius: 3)
            
            VStack(alignment: .leading) {
                HStack {
                    Text(statistic.longName)
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    if let systemName = statistic.symbol(of: instance) {
                        Image(systemName: systemName)
                            .foregroundColor(statistic.symbolColor(of: instance))
                    }
                }
                
                Text(statistic.value(of: instance))
                    .font(.title)
                    .fontWeight(.black)
            }
            .padding()
        }
    }
}

struct StatisticCard_Previews: PreviewProvider {
    static var previews: some View {
        StatisticCard(Statistic.personalBest, instance: Instance())
    }
}

