//
//  Statistic.swift
//  Cubing Timer
//
//  Created by Cameron Delong on 8/5/21.
//

struct Statistic {
    // MARK: Properties
    /// The type of `Statistic` being tracked.
    var kind: Kind
    /// An extra option for the `Statistic`. (`nil` if not applicable)
    var modifier: Int?
    
    /// The `Instance` that the `Statistic` belongs to.
    private var instance: Instance!
    
    /// Abbreviated version of the `Statistic`'s name.
    var shortName: String {
        switch kind {
        case .average:
            return "ao\(modifier ?? 5)"
        case .mean:
            return "mo\(modifier ?? 5)"
        }
    }
    
    /// Full version of the `Statistic`'s name.
    var longName: String {
        switch kind {
        case .average:
            return "Average of \(modifier ?? 5)"
        case .mean:
            return "Mean of \(modifier ?? 5)"
        }
    }
    
    /// Full name of `Statistic`'s extra option. (`nil` if no additional option)
    var modifierTitle: String? {
        switch kind {
        case .average:
            return "Average of"
        case .mean:
            return "Mean of"
        }
    }
    
    /// The computed value of the `Statistic`.
    var value: String {
        switch kind {
        case .average:
            return instance.formattedAverage(of: modifier ?? 5)
        case .mean:
            return instance.formattedMean(of: modifier ?? 5)
        }
    }
    
    /// `Array` of `Strings` that give extra information about the `Statistic`.
    var details: [String]? {
        switch kind {
        case .average:
            let solves = instance.solveArray.suffix(modifier ?? 5)
            
            let outliers = max(solves.count / 5, 1)
            
            let sorted = solves.sorted {
                if $0.penalty == .dnf {
                    return false
                }
                
                if $1.penalty == .dnf {
                    return true
                }
                
                return $0.adjustedTime < $1.adjustedTime
            }
            
            let outlierArray = sorted.prefix(outliers) + sorted.suffix(outliers)

            return solves.map { solve -> String in
                if outlierArray.contains(solve) {
                    return "(\(solve.formattedTime))"
                }
                
                return solve.formattedTime
            }.reversed()
            
        case .mean:
            return instance.solveArray.filter { $0.penalty != .dnf }.suffix(modifier ?? 5).map { Solve.formatTime($0.adjustedTime) }
        }
    }
    
    /// A closure to perform when a button next to a detail row is pressed.
    var action: ((Int) -> Void)? {
        switch kind {
        case .average:
            return { index in
                if instance.solveArray.count > index {
                    if instance.solveArray.count > index {
                        SolveStorage.delete(instance.solveArray.suffix(index + 1).first!)
                    }
                }
            }
            
        case .mean:
            return { index in
                if instance.solveArray.count > index {
                    if instance.solveArray.count > index {
                        SolveStorage.delete(instance.solveArray.suffix(index + 1).first!)
                    }
                }
            }
        }
    }
    
    /// The system image on the button that performs the action.
    var actionSymbol: String? {
        switch kind {
        case .average:
            return "trash"
        case .mean:
            return "trash"
        }
    }
    
    // MARK: Initializers
    /// Creates an instance of `Statistic` from its `Kind`, and a modifier if applicable.
    init(kind: Kind, modifier: Int? = nil, instance: Instance? = nil) {
        self.kind = kind
        self.modifier = modifier
        self.instance = instance
    }
    
    /// Creates an instance of `Statistic` from a serialized `String`.
    init(_ description: String, instance: Instance? = nil) {
        let components = description.split(separator: ":")
        
        self.init(kind: Kind(rawValue: String(components.first ?? "average")) ?? .average, modifier: Int(components.last ?? "5"), instance: instance)
    }
    
    // MARK: Types
    /// An enum containing all the possible `Statistic`s the user can track.
    enum Kind: String, CaseIterable {
        // MARK: Cases
        /// The mean of the most recent `n` solves, excluding the fastest and slowest.
        case average = "average"
        /// The mean of the most recent `n` solves.
        case mean = "mean"
        
        // MARK: Properties
        /// Stylized version of the statistic's name.
        var formattedName: String {
            return self.rawValue.capitalized
        }
    }
    
    // MARK: Methods
    /// Sets the `Statistic`'s corresponding instance.
    mutating func setInstance(to instance: Instance) {
        self.instance = instance
    }
}

extension Statistic: CustomStringConvertible {
    // MARK: Properties
    /// Serialized value of the `Statistic` for persistence.
    var description: String {
        switch kind {
        case .average:
            return "average:\(modifier ?? 5)"
        case .mean:
            return "mean:\(modifier ?? 5)"
        }
    }
}

extension Statistic: Hashable {
    // MARK: Methods
    func hash(into hasher: inout Hasher) {
        hasher.combine(description)
    }

    static func == (lhs: Statistic, rhs: Statistic) -> Bool {
        lhs.description == rhs.description
    }
}
