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
            VStack(alignment: .leading) {
                Text(solve.formattedTime)
                if let scramble = solve.scramble {
                    Text(scramble)
                        .foregroundColor(.gray)
                        .font(.caption)
                }
            }
            
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

//This crashes Xcode. I don't think it likes me making a CoreData object for a preview
/*
struct SolveRow_Previews: PreviewProvider {
    static var shared = Self()
    
    var solve: Solve
    
    init() {
        solve = Solve()
        
        solve.time = 29.9111
        solve.date = Date()
        solve.scramble = "R U R D R U2 D2 B2 F U' F2"
    }
    
    static var previews: some View {
        SolveRow(shared.solve)
            
    }
}
*/
