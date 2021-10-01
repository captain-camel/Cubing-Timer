//
//  SolveRow.swift
//  SolveRow
//
//  Created by Cameron Delong on 9/30/21.
//

import SwiftUI

/// A row of a list displaying a `Solve`.
struct SolveRow: View {
    // MARK: Properties
    /// The displayed `Solve`.
    @ObservedObject var solve: Solve
    
    // MARK: Initializers
    init(_ solve: Solve) {
        self.solve = solve
    }
    
    // MARK: Body
    var body: some View {
        HStack {
            Text(solve.formattedTime)
            
            Spacer()
            
            Button {
                solve.delete()
            } label: {
                Image(systemName: "trash")
            }
            .buttonStyle(BorderlessButtonStyle())
        }
    }
}
