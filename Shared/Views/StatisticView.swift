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
    
    // MARK: Body
    var body: some View {
        if statistic.details == nil {
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
                    Text(String(statistic.shortName))
                }
                .lineLimit(1)
            }
            .buttonStyle(StatisticButtonStyle())
            .disabled(statistic.details!.isEmpty)
            .onDevice(.pad) { view in
                view.popover(isPresented: $showingDetails) {
                    ListPopover(values: statistic.details!)
                }
            }
//            .onDevice(.phone) { view in
//                view.sheet(isPresented: $showingDetails) {
//                    ListSheet(title: title, details: details!, action: action, actionSymbolName: actionSymbolName)
//                }
//            }
        }
    }
}
