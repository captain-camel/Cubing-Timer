//
//  ListPopover.swift
//  Cubing Timer
//
//  Created by Cameron Delong on 8/7/21.
//

import SwiftUI

/// A popover displaing a list of items.
struct ListPopover: View {
    // MARK: Properties
    /// The array of vales to display.
    var values: [String]
    
    /// Whether there are more values than the limit and they are concatenated.
    var valuesConcatenated: Bool = false
    
    /// A closure that is called when the button next to a row is pressed.
    var action: ((_ index: Int) -> Void)?
    /// The SF symbol on the button in each row.
    var actionSymbol: String?
    
    // MARK: Initializers
    init(values: [String], limit: Int, action: ((_ index: Int) -> Void)? = nil, actionSymbol: String? = nil) {
        if values.count > limit {
            self.values = values.suffix(limit - 1) + ["\(values.count - (limit - 1)) more..."]
            valuesConcatenated = true
        } else {
            self.values = values
        }
        
        self.action = action
        self.actionSymbol = actionSymbol
    }
    
    // MARK: Body
    var body: some View {
        VStack(spacing: 0) {
            ForEach(Array(values.enumerated()), id: \.offset) { index, value in
                PopoverRow(index: !((index == values.indices.last!) && valuesConcatenated) ? index : nil, value: value, action: action, actionSymbol: actionSymbol)
                    .if(index % 2 == 0) { view in
                        view.background(
                            Color(.systemGray5)
                                .cornerRadius(5)
                        )
                    }
            }
        }
        .padding()
    }
}
