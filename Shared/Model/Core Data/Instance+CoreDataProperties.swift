//
//  Instance+CoreDataProperties.swift
//  Cubing Timer
//
//  Created by Cameron Delong on 8/7/21.
//
//

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
    
    /// Whether the instance has an inspection countdown before the timer starts.
    @NSManaged public var doInspection: Bool
    /// The length of the inspection before the timer starts.
    @NSManaged public var inspectionDuration: Int64
    
    /// Whether the `Instance` shows a scramble.
    @NSManaged public var showScramble: Bool
    /// A cutom scramble algorithm written in javascript.
    @NSManaged public var customScrambleAlgorithm: String
    
    /// The set of all the `Solve`s in the `Instance`.
    @NSManaged public var solves: NSSet?
    
    /// The array of all the `Solve`s in the instance, sorted by `Date`.
    var solveArray: [Solve] {
        let set = solves as? Set<Solve> ?? []
        return set.sorted {
            $0.date < $1.date
        }
    }
    
    /// Safely unwrapped value of `solves`.
    var unwrappedSolves: NSSet {
        return solves ?? []
    }
    
    /// The puzzle assigned to the `Instance`.
    var puzzle: Puzzle {
        get {
            return Puzzle(serialized: puzzleRawValue)
        }
        set {
            puzzleRawValue = newValue.serialized
        }
    }
    
    /// The first statistic displayed by the instance.
    var primaryStatistic: Statistic {
        get {
            return Statistic(serialized: primaryStatisticRawValue) ?? .average(5)
        }
        set {
            primaryStatisticRawValue = newValue.serialized
        }
    }
    
    /// The second statistic displayed by the instance.
    var secondaryStatistic: Statistic {
        get {
            return Statistic(serialized: secondaryStatisticRawValue) ?? .average(12)
        } set {
            secondaryStatisticRawValue = newValue.serialized
        }
    }
    
    /// The duration of the `Instance`'s inspection, as an `Optional`.
    var wrappedInspectionDuration: Int? {
        get {
            if doInspection {
                return Int(inspectionDuration)
            }
            
            return nil
        }
        set {
            if newValue != nil {
                inspectionDuration = Int64(newValue!)
                
                doInspection = true
            } else {
                inspectionDuration = 15
                
                doInspection = false
            }
        }
    }
    
    // MARK: Methods
    /// Adds a new `Solve` to the instance and saves it to Core Data.
    func addSolve(time: Double, date: Date = Date(), penalty: Solve.Penalty = .none, scramble: String? = nil) {
        SolveStorage.add(time: time, date: date, penalty: penalty, scramble: scramble, instance: self)
        
        PersistenceController.save()
    }
    
    /// Returns the average time of the last solves. (Fastest and slowest times excluded.) The number of solves is determinted by the paramter `count`.
    func average(of count: Int) -> Double? {
        let outliers = max(count / 5, 1)
        
        if unwrappedSolves.count >= count && solveArray.suffix(count).filter({ $0.penalty == .dnf }).count <= outliers && count >= 3 {
            return solveArray.suffix(count).map { $0.penalty == .dnf ? Double.greatestFiniteMagnitude : $0.adjustedTime }.removingOutliers(outliers).mean
        }
        
        return nil
    }
    
    /// Returns the average time of a range of solves.
    func average(indices: ClosedRange<Int>) -> Double? {
        let outliers = max(indices.count / 5, 1)
        
        if unwrappedSolves.count >= indices.count && solveArray.suffix(indices.last! + 1).prefix(indices.count).filter({ $0.penalty == .dnf }).count <= outliers && indices.count >= 3 {
            return solveArray.suffix(indices.last! + 1).prefix(indices.count).map { $0.penalty == .dnf ? Double.greatestFiniteMagnitude : $0.adjustedTime }.removingOutliers(outliers).mean
        }
        
        return nil
    }
    
    /// Returns the average time of the last solves, formatted into a `String`.
    func formattedAverage(of count: Int) -> String {
        let outliers = max(count / 5, 1)
        
        if solveArray.suffix(count).filter({ $0.penalty == .dnf }).count > outliers {
            return "DNF"
        }
        
        return Solve.formatTime(average(of: count))
    }
    
    /// Returns the mean of the last solves.
    func mean(of count: Int) -> Double? {
        if solveArray.suffix(count).filter({ $0.penalty != .dnf }).count >= count {
            return solveArray.filter { $0.penalty != .dnf }.suffix(count).map { $0.adjustedTime }.mean
        }
        
        return nil
    }
    
    /// Returns the mean of th elast solves, formatted into a `String`.
    func formattedMean(of count: Int) -> String {
        return Solve.formatTime(mean(of: count))
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
