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
    
    /// Whether a `ListPopover` is currently displayed.
    @State private var showingDetails = false
    
    /// Whether the `StatisticView` shows a popover when pressed if applicable.
    var popover: Bool
    
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
                .lineLimit(1)
            }
            .buttonStyle(StatisticButtonStyle())
            .disabled(statistic.details!.isEmpty)
            .if(Device.shared.currentDevice == .pad) { view in
                view.popover(isPresented: $showingDetails) {
                    ListPopover(values: statistic.details!, limit: 10, action: statistic.action, actionSymbol: statistic.actionSymbol)
                        .fixedSize()
                }
            }
            .if(Device.shared.currentDevice == .phone) { view in
                view.sheet(isPresented: $showingDetails) {
                    ListPopover(values: statistic.details!, limit: 15, action: statistic.action, actionSymbol: statistic.actionSymbol)
                }
            }
        }
    }
}
