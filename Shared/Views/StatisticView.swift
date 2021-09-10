//
//  StatisticView.swift
//  Cubing Timer
//
//  Created by Cameron Delong on 8/7/21.
//

import SwiftUI

/// A view that displays a statistic's name and value, and a popover with more information if applicable.
struct StatisticView: View {
    // MARK: Properties
    /// The `Statistic` described by the `StatisticView`.
    var statistic: Statistic
    /// The `Instance` who's `Statistic` is displayed.
    @ObservedObject var instance: Instance
    
    /// Whether the `StatisticView` shows a popover when pressed if applicable.
    var popover: Bool
    
    /// Whether a `ListPopover` is currently displayed.
    @State private var showingDetails = false
    
    // MARK: Initializers
    init(_ statistic: Statistic, instance: Instance, popover: Bool = true) {
        self.statistic = statistic
        self.instance = instance
        
        self.popover = popover
    }
    
    // MARK: Body
    var body: some View {
        if statistic.details(of: instance) == nil || !popover {
            HStack {
                Text("\(statistic.shortName):")
                    .foregroundColor(.secondary)
                Text(statistic.value(of: instance))
                
                if let systemName = statistic.symbol(of: instance) {
                    Image(systemName: systemName)
                        .foregroundColor(statistic.symbolColor(of: instance))
                }
            }
            .lineLimit(1)
        } else {
            Button {
                showingDetails.toggle()
            } label: {
                HStack {
                    Text("\(statistic.shortName):")
                        .foregroundColor(.secondary)
                    Text(statistic.value(of: instance))
                    
                    if let systemName = statistic.symbol(of: instance) {
                        Image(systemName: systemName)
                            .foregroundColor(statistic.symbolColor(of: instance))
                    }
                }
                .lineLimit(1)
            }
            .buttonStyle(StatisticButtonStyle())
            .disabled(statistic.details(of: instance)!.isEmpty)
            .if(Device() == .pad) { view in
                view.popover(isPresented: $showingDetails) {
                    ListPopover(values: statistic.details(of: instance)!, limit: 10, action: statistic.action(of: instance), actionSymbol: statistic.actionSymbol)
                        .fixedSize()
                }
            }
            .if(Device() == .phone) { view in
                view.sheet(isPresented: $showingDetails) {
                    ListSheet(title: statistic.longName, values: statistic.details(of: instance)!, action: statistic.action(of: instance), actionSymbol: statistic.actionSymbol)
                }
            }
        }
    }
}
