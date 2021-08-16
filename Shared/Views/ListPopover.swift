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
    /// Whether the values are concatinated.
    var valuesConcatenated = false
    
    // MARK: Initializers
    init(values: [String]) {
        if values.count > 10 {
            self.values = values.suffix(9) + ["\(values.count - 9) more..."]
            self.valuesConcatenated = true
        } else {
            self.values = values
        }
    }
    
    // MARK: Body
    var body: some View {
        VStack {
            ForEach(values, id: \.self) { value in
                Text(value)
            }
        }
    }
}
