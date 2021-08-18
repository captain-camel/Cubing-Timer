//
//  ListPopover.swift
//  Cubing Timer
//
//  Created by Cameron Delong on 8/7/21.
//

import SwiftUI

/// A popover displaing a list of items with a limit of 10.
struct ListPopover: View {
    // MARK: Properties
    /// The array of vales to display.
    var values: [String]
    
    /// Whether there are more values than the limit and they are concatenated.
    var valuesConcatenated: Bool = false
    
    /// A closure that is called when the button next to a row is pressed.
    var action: ((_ index: Int) -> Void)?
    /// The SF symbol on the button in each row.
    var actionSymbolName: String?
    
    // MARK: Initializers
    init(values: [String], limit: Int = 10) {
        if values.count > limit {
            self.values = values.suffix(limit - 1) + ["\(values.count - (limit - 1)) more..."]
            valuesConcatenated = true
            
        } else {
            self.values = values
        }
    }
    
    // MARK: Body
    var body: some View {
        VStack {
            ForEachWithIndex(values, id: \.self) { index, value in
                HStack {
                    if !(index == values.indices.last && valuesConcatenated) {
                        Text("\(index).")
                            .foregroundColor(.secondary)
                    }

                    Text(value)

                    if action != nil && !(index == values.indices.last && valuesConcatenated) {
                        Spacer()

                        Button {
                            action!(index)
                        } label: {
                            Image(systemName: actionSymbolName ?? "questionmark")
                        }
                        .frame(alignment: .trailing)
                        .padding()
                    }
                }
                .if((values.count - index) % 2 == 0) { view in
                    view.background(
                        Color(.systemGray5)
                            .cornerRadius(5)
                    )
                }
            }
        }
    }
}
