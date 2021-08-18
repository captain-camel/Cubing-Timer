//
//  ListSheet.swift
//  Cubing Timer
//
//  Created by Cameron Delong on 8/18/21.
//

import SwiftUI

/// A popover displaying a list of items.
struct ListSheet: View {
    // MARK: Properties
    /// The presentation mode of the sheet.
    @Environment(\.presentationMode) var presentationMode
    
    /// The title of the popover.
    var title: String
    
    /// The array of vales to display.
    var values: [String]
    
    /// Whether there are more values than the limit and they are concatenated.
    var valuesConcatenated: Bool = false
    
    /// A closure that is called when the button next to a row is pressed.
    var action: ((_ index: Int) -> Void)?
    /// The SF symbol on the button in each row.
    var actionSymbol: String?
    
    // MARK: Initializers
    init(title: String, values: [String], limit: Int, action: ((_ index: Int) -> Void)? = nil, actionSymbol: String? = nil) {
        self.title = title
        
        if values.count > limit {
            self.values = values.prefix(limit - 1) + ["\(values.count - (limit - 1)) more..."]
            valuesConcatenated = true
        } else {
            self.values = values
        }
        
        self.action = action
        self.actionSymbol = actionSymbol
    }
    
    // MARK: Body
    var body: some View {
        NavigationView {
            ScrollView {
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
            .navigationBarTitle(title, displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}
