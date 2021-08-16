//
//  Instance+CoreDataProperties.swift
//  Cubing Timer
//
//  Created by Cameron Delong on 8/7/21.
//
//

import Foundation
import CoreData


extension Instance {
    // MARK: Properties
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Instance> {
        return NSFetchRequest<Instance>(entityName: "Instance")
    }

    /// The name of the `Instance`.
    @NSManaged public var name: String
    /// Serialized string of the puzzle assigned to the `Instance`.
    @NSManaged public var puzzleRawValue: String
    /// Notes about the  `Instance`.
    @NSManaged public var notes: String?
    /// The position that the `Instance` appears in when all `Instance`s are listed.
    @NSManaged public var order: Int16
    /// An identifier unique to the `Instance`.
    @NSManaged public var id: UUID
    
    /// Serialized string of the first statistic displayed by the `Instance`.
    @NSManaged public var primaryStatisticRawValue: String
    /// Serialized string of the second statistic displayed by the `Instance`.
    @NSManaged public var secondaryStatisticRawValue: String
    
    /// The set of all the `Solve`s in the `Instance`.
    @NSManaged public var solves: NSSet?
    
    /// The array of all the `Solve`s in the instance, sorted by `Date`.
    var solveArray: [Solve] {
        print(Int.random(in: 1...10))
        let set = solves as? Set<Solve> ?? []
        return set.sorted {
            $0.date < $1.date
        }
    }
    
    /// The puzzle assigned to the `Instance`.
    var puzzle: Puzzle {
        get {
            return Puzzle(puzzleRawValue)
        }
        set {
            puzzleRawValue = newValue.stringValue
        }
    }
    
    /// The first statistic displayed by the instance.
    var primaryStatistic: Statistic {
        get {
            return Statistic(from: primaryStatisticRawValue, instance: self)
        }
        set {
            primaryStatisticRawValue = newValue.rawValue
        }
    }
    
    /// The second statistic displayed by the instance.
    var secondaryStatistic: Statistic {
        get {
            return Statistic(from: secondaryStatisticRawValue, instance: self)
        } set {
            secondaryStatisticRawValue = newValue.rawValue
        }
    }
    
    // MARK: Methods
    /// Adds a new `Solve` to the instance and saves it to Core Data.
    func addSolve(time: Double, date: Date = Date(), plusTwo: Bool = false, dnf: Bool = false, scramble: String? = nil) {
        SolveStorage.shared.add(time: time, date: date, plusTwo: plusTwo, dnf: dnf, scramble: scramble, instance: self)
        
        PersistenceController.save()
    }
    
    /// Returns the average time of the last solves. (Fastest and slowest times excluded.) The number of solves is determinted by the paramter `count`.
    func average(of count: Int) -> Double? {
        let tempSolveArray = solveArray
        if tempSolveArray.count >= count && count >= 3 {
            var times = tempSolveArray.suffix(count).map { $0.time }
            let minIndex = times.firstIndex(of: times.min() ?? 0) ?? 0
            times.remove(at: minIndex)
            let maxIndex = times.firstIndex(of: times.max() ?? 0) ?? 0
            times.remove(at: maxIndex)
            
            return times.average
        } else {
            return nil
        }
    }
}

// MARK: Generated accessors for solves
extension Instance {

    @objc(addSolvesObject:)
    @NSManaged public func addToSolves(_ value: Solve)

    @objc(removeSolvesObject:)
    @NSManaged public func removeFromSolves(_ value: Solve)

    @objc(addSolves:)
    @NSManaged public func addToSolves(_ values: NSSet)

    @objc(removeSolves:)
    @NSManaged public func removeFromSolves(_ values: NSSet)

}

extension Instance: Identifiable {

}
