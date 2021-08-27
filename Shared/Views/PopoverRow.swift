//
//  PopoverRow.swift
//  Cubing Timer
//
//  Created by Cameron Delong on 8/18/21.
//

import SwiftUI

/// A row of a popover with `Statistic` details.
struct PopoverRow: View {
    /// The `Int` shown at the start of the row.
    var index: Int?
    /// The `String` shown in the row.
    var value: String
    
    /// A closure that is called when the button in the `PopoverRow` is pressed.
    var action: ((_ index: Int) -> Void)?
    /// The SF symbol on the button in the `PopoverRow`.
    var actionSymbol: String?
    
    // MARK: Body
    var body: some View {
        HStack {
            if index != nil {
                Text("\(index! + 1).")
                    .foregroundColor(.secondary)
                    .padding(.leading)
            }

            Text(value)
                .padding()
            
            Spacer()

            if action != nil && index != nil {
                Button {
                    action!(index!)
                } label: {
                    Image(systemName: actionSymbol ?? "questionmark")
                }
                .frame(alignment: .trailing)
                .padding()
            }
        }
    }
}
