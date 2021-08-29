//
//  Solve+CoreDataProperties.swift
//  Cubing Timer
//
//  Created by Cameron Delong on 8/7/21.
//
//

import CoreData

extension Solve {
    // MARK: Properties
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Solve> {
        return NSFetchRequest<Solve>(entityName: "Solve")
    }

    /// The time the solve took to complete.
    @NSManaged public var time: Double
    /// The time and date the solve was recorded.
    @NSManaged public var date: Date
    /// Serialized representation of the `Solve`'s `Penalty`.
    @NSManaged public var penaltyRawValue: String
    /// The scramble that was solved. (`nil` if the puzzle doesn't have a scrambler or if there is no scramble for any reason)
    @NSManaged public var scramble: String?
    
    /// The `Instance` containing the solve.
    @NSManaged public var instance: Instance?
    
    /// The `Solve`'s `time` adjusted to include any penalties.
    var adjustedTime: Double {
        return time + Double(penalty.length ?? 0)
    }
    
    /// The `Solve`'s `Penalty`.
    var penalty: Penalty {
        get {
            switch penaltyRawValue {
            case "none":
                return .none
            case "dnf":
                return .dnf
            default:
                return Int(penaltyRawValue) != nil ? .some(Int(penaltyRawValue)!) : .none
            }
        }
        set {
            switch newValue {
            case .none:
                penaltyRawValue = "none"
            case .dnf:
                penaltyRawValue = "dnf"
            case let .some(seconds):
                penaltyRawValue = String(seconds)
            }
        }
    }
    
    /// The solve's time formatted into hours, minutes, seconds, and hundredths of seconds.
    var formattedTime: String {
        return Solve.formatTime(time)
    }
    
    // MARK: Methods
    /// Returns a `Double` formatted into hours, minutes, seconds, and hundredths of seconds.
    static func formatTime(_ time: Double?, places: Int = 2, secondsOnly: Bool = false) -> String {
        if time != nil {
            if secondsOnly {
                return String(format: "%.\(places)f", time!)
            }
            
            let hours = Int(time!) / 3600
            let minutes = Int(time!) / 60 % 60
            let seconds = time!.truncatingRemainder(dividingBy: 60)
            
            let hoursString = hours != 0 ? String(format: "%d:", hours) : ""
            
            var minutesString = minutes != 0 || hours != 0 ? String(format: "%d:", minutes) : ""
            if minutes < 10 && hours > 0 {
                minutesString = "0\(minutesString)"
            }
            
            var secondsString = String(format: "%.\(places)f", seconds)
            if seconds < 10 && minutes > 0 {
                secondsString = "0\(secondsString)"
            }
            
            return "\(hoursString)\(minutesString)\(secondsString)"
        }
        
        return "--.--"
    }
    
    /// Deletes the `Solve`.
    func delete() {
        PersistenceController.viewContext.delete(self)
        
        PersistenceController.save()
    }
    
    // MARK: Types
    /// Possible penalties on a `Solve`.
    enum Penalty: Equatable {
        // MARK: Cases
        /// No penalty.
        case none
        /// The solve was unfinished.
        case dnf
        /// A penalty of some number of seconds.
        case some(Int)
        
        // MARK: Properties
        /// The length of the `Penalty` in seconds.
        var length: Int? {
            switch self {
            case let .some(seconds):
                return seconds
            default:
                return nil
            }
        }
    }
}

extension Solve: Identifiable {

}
