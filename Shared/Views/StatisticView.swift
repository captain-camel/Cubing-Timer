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
    @Binding var statistic: Statistic
    
    /// Whether the `StatisticView` shows a popover when pressed if applicable.
    var popover: Bool
    
    /// Whether a `ListPopover` is currently displayed.
    @State private var showingDetails = false
    
    // MARK: Initializers
    init(_ statistic: Binding<Statistic>, popover: Bool = true) {
        self._statistic = statistic
        self.popover = popover
    }
    
    // MARK: Body
    var body: some View {
        if statistic.details == nil || !popover {
            HStack {
                Text("\(statistic.shortName):")
                    .foregroundColor(.secondary)
                Text(statistic.value)
            }
            .animation(nil)
            .lineLimit(1)
        } else {
            Button {
                showingDetails.toggle()
            } label: {
                HStack {
                    Text("\(statistic.shortName):")
                        .foregroundColor(.secondary)
                    Text(statistic.value)
                }
                .animation(nil)
                .lineLimit(1)
            }
            .buttonStyle(StatisticButtonStyle())
            .disabled(statistic.details!.isEmpty)
            .if(Device() == .pad) { view in
                view.popover(isPresented: $showingDetails) {
                    ListPopover(values: statistic.details!, limit: 10, action: statistic.action, actionSymbol: statistic.actionSymbol)
                        .fixedSize()
                }
            }
            .if(Device() == .phone) { view in
                view.sheet(isPresented: $showingDetails) {
                    ListSheet(title: statistic.longName, values: statistic.details!, action: statistic.action, actionSymbol: statistic.actionSymbol)
                }
            }
        }
    }
}
