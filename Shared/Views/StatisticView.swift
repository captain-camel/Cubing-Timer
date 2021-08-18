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
    var popover: Bool = false
    
    // MARK: Body
    var body: some View {
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
        .disabled(statistic.details == nil || statistic.details!.isEmpty || !popover)
        .if(statistic.details != nil && popover) { view in
            view.if(Device.shared.currentDevice == .pad) { view in
                view.sheet(isPresented: $showingDetails) {
                    ListPopover(values: statistic.details!)
                }
            }
        }
    }
}
