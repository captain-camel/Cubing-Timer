//
//  SolveStorage.swift
//  Cubing Timer
//
//  Created by Cameron Delong on 8/7/21.
//

import Foundation

class SolveStorage {
    // MARK: Methods
    /// Creates a new `Solve` and saves it to Core Data.
    static func add(time: Double, date: Date = Date(), plusTwo: Bool = false, dnf: Bool = false, scramble: String? = nil, instance: Instance) {
        let newSolve = Solve(context: PersistenceController.viewContext)
        
        newSolve.time = time
        newSolve.date = date
        newSolve.plusTwo = plusTwo
        newSolve.dnf = dnf
        newSolve.scramble = scramble
        
        instance.addToSolves(newSolve)
        
        PersistenceController.save()
    }
    
    /// Deletes a `Solve`.
    static func delete(_ solve: Solve) {
        PersistenceController.viewContext.delete(solve)
        
        PersistenceController.save()
    }
}
