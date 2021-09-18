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
                    if solve!.penalty.length != nil {
                        solve!.penalty = .none
                    } else {
                        solve!.penalty = .some(2)
                    }
                }
            } label: {
                Text("+\(solve?.penalty.length ?? 2)")
                    .if(solve?.penalty.length != nil) { $0.bold() }
            }
            .contentShape(RoundedRectangle(cornerRadius: 8))
            .buttonStyle(TimerActionButtonStyle(isActive: solve?.penalty.length != nil))
            
            Button {
                withAnimation {
                    if solve!.penalty == .dnf {
                        solve!.penalty = .none
                    } else {
                        solve!.penalty = .dnf
                    }
                }
            } label: {
                Text("DNF")
                    .if(solve?.penalty == .dnf) { $0.bold() }
            }
            .buttonStyle(TimerActionButtonStyle(isActive: solve?.penalty == .dnf))
            
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
