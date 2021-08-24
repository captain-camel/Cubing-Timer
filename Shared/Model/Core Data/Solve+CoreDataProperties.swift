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
    /// Whether the solve has a +2 second penalty.
    @NSManaged public var plusTwo: Bool
    /// Whether the solve was not completed.
    @NSManaged public var dnf: Bool
    /// The scramble that was solved. (`nil` if the puzzle doesn't have a scrambler or if there is no scramble for any reason)
    @NSManaged public var scramble: String?
    
    /// The `Instance` containing the solve.
    @NSManaged public var instance: Instance?
    
    /// The solve's time formatted into hours, minutes, seconds, and hundredths of seconds.
    var formattedTime: String {
        return Solve.formatTime(time)
    }
    
    // MARK: Methods
    /// Returns a `Double` formatted into hours, minutes, seconds, and hundredths of seconds.
    static func formatTime(_ time: Double?, places: Int = 2) -> String {
        if time != nil {
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
            
        } else {
            return "--.--"
        }
    }
    
    /// Deletes the `Solve`.
    func delete() {
        PersistenceController.viewContext.delete(self)
        
        PersistenceController.save()
    }
}

extension Solve: Identifiable {

}
