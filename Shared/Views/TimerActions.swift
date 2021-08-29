//
//  TimerActions.swift
//  Cubing Timer
//
//  Created by Cameron Delong on 8/26/21.
//

import SwiftUI

/// A view with buttons that edit the previous `Solve`.
struct TimerActions: View {
    // MARK: Properties
    /// The `Solve` being acted on.
    @ObservedOptionalObject var solve: Solve?
    
    // MARK: Body
    var body: some View {
        Group {
            Button {
                withAnimation {
                    solve!.plusTwo.toggle()
                }
            } label: {
                Text("+2")
                    .if(solve?.plusTwo ?? false) { $0.bold() }
            }
            .buttonStyle(TimerActionButtonStyle(isActive: solve?.plusTwo ?? false))
            
            Button {
                withAnimation {
                    solve!.dnf.toggle()
                }
            } label: {
                Text("DNF")
                    .if(solve?.dnf ?? false) { $0.bold() }
            }
            .buttonStyle(TimerActionButtonStyle(isActive: solve?.dnf ?? false))
            
            Button {
                SolveStorage.delete(solve!)
            } label: {
                Image(systemName: "trash")
            }
            .buttonStyle(TimerActionButtonStyle(isActive: false))
        }
        .disabled(solve == nil)
    }
}
