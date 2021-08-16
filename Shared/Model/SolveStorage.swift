//
//  SolveStorage.swift
//  Cubing Timer
//
//  Created by Cameron Delong on 8/7/21.
//

import Foundation

class SolveStorage {
    // MARK: Properties
    /// A singleton instance of `SolveStorage`.
    static let shared = SolveStorage()

    // MARK: Methods
    /// Creates a new `Solve` and saves it to Core Data.
    func add(time: Double, date: Date = Date(), plusTwo: Bool = false, dnf: Bool = false, scramble: String? = nil, instance: Instance) {
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
    func delete(_ solve: Solve) {
        PersistenceController.viewContext.delete(solve)
        
        PersistenceController.save()
    }
}
