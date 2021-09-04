//
//  Statistic.swift
//  Cubing Timer
//
//  Created by Cameron Delong on 8/5/21.
//

//struct Statistic {
//    // MARK: Properties
//    /// The type of `Statistic` being tracked.
//    var kind: Kind
//    /// An extra option for the `Statistic`. (`nil` if not applicable)
//    var modifier: Int?
//
//    /// The `Instance` that the `Statistic` belongs to.
//    private var instance: Instance!
//
//    /// Abbreviated version of the `Statistic`'s name.
//    var shortName: String {
//        switch kind {
//        case .average:
//            return "ao\(modifier ?? 5)"
//        case .mean:
//            return "mo\(modifier ?? 5)"
//        case .personalBest:
//            return "pb"
//        }
//    }
//
//    /// Full version of the `Statistic`'s name.
//    var longName: String {
//        switch kind {
//        case .average:
//            return "Average of \(modifier ?? 5)"
//        case .mean:
//            return "Mean of \(modifier ?? 5)"
//        case .personalBest:
//            return "Personal Best"
//        }
//    }
//
//    /// Full name of `Statistic`'s extra option. (`nil` if no additional option)
//    var modifierTitle: String? {
//        switch kind {
//        case .average:
//            return "Average of"
//        case .mean:
//            return "Mean of"
//        default:
//            return nil
//        }
//    }
//
//    /// The computed value of the `Statistic`.
//    var value: String {
//        switch kind {
//        case .average:
//            return instance.formattedAverage(of: modifier ?? 5)
//        case .mean:
//            return instance.formattedMean(of: modifier ?? 5)
//        case .personalBest:
//            return Solve.formatTime(instance.unwrappedSolves.map { ($0 as? Solve)?.adjustedTime ?? 0 }.max())
//        }
//    }
//
//    /// `Array` of `Strings` that give extra information about the `Statistic`.
//    var details: [String]? {
//        switch kind {
//        case .average:
//            let solves = instance.solveArray.suffix(modifier ?? 5)
//
//            let outliers = max(solves.count / 5, 1)
//
//            let sorted = solves.sorted {
//                if $0.penalty == .dnf {
//                    return false
//                }
//
//                if $1.penalty == .dnf {
//                    return true
//                }
//
//                return $0.adjustedTime < $1.adjustedTime
//            }
//
//            let outlierArray = sorted.prefix(outliers) + sorted.suffix(outliers)
//
//            return solves.map { solve -> String in
//                if outlierArray.contains(solve) {
//                    return "(\(solve.formattedTime))"
//                }
//
//                return solve.formattedTime
//            }.reversed()
//
//        case .mean:
//            return instance.solveArray.filter { $0.penalty != .dnf }.suffix(modifier ?? 5).map { Solve.formatTime($0.adjustedTime) }
//
//        default:
//            return nil
//        }
//    }
//
//    /// A closure to perform when a button next to a detail row is pressed.
//    var action: ((Int) -> Void)? {
//        switch kind {
//        case .average:
//            return { index in
//                if instance.unwrappedSolves.count > index {
//                    if instance.unwrappedSolves.count > index {
//                        SolveStorage.delete(instance.solveArray.suffix(index + 1).first!)
//                    }
//                }
//            }
//
//        case .mean:
//            return { index in
//                if instance.unwrappedSolves.count > index {
//                    if instance.unwrappedSolves.count > index {
//                        SolveStorage.delete(instance.solveArray.suffix(index + 1).first!)
//                    }
//                }
//            }
//
//        default:
//            return nil
//        }
//    }
//
//    /// The system image on the button that performs the action.
//    var actionSymbol: String? {
//        switch kind {
//        case .average:
//            return "trash"
//        case .mean:
//            return "trash"
//        default:
//            return nil
//        }
//    }
//
//    /// Serialized `String` representation of the `Statistic`.
//    var serialized: String {
////        switch kind {
////        case .average:
////            return "average:\(modifier ?? 5)"
////        case .mean:
////            return "mean:\(modifier ?? 5)"
////        case .personalBest:
////            return "personalBest"
////        }
//        return "\(kind.rawValue)\(modifier != nil ? ":\(modifier!)" : "")"
//    }
//
//    // MARK: Initializers
//    /// Creates an instance of `Statistic` from its `Kind`, and a modifier if applicable.
//    init(kind: Kind, modifier: Int? = nil, instance: Instance? = nil) {
//        self.kind = kind
//        self.modifier = modifier
//        self.instance = instance
//    }
//
////    /// Creates an instance of `Statistic` from a serialized `String`.
////    init(_ description: String, instance: Instance? = nil) {
////        let components = description.split(separator: ":")
////
////        self.init(kind: Kind(rawValue: String(components.first ?? "Average")) ?? .average, modifier: Int(components[safe: 1] ?? ""), instance: instance)
////    }
//    // MARK: Initializers
//    /// Creates a `Statistic` from a serialized `String`.
//    init?(_ description: String, instance: Instance? = nil) {
//        let components = description.split(separator: ":")
//
//        guard let first = components.first else {
//            return nil
//        }
//
//        guard let kind = Kind(rawValue: String(first)) else {
//            return nil
//        }
//
//        self.kind = kind
//
//        let second = components[safe: 1] ?? "5"
//
//        self.modifier = Int(second) ?? 5
//
//        self.instance = instance
//    }
//
//    // MARK: Types
//    /// An enum containing all the possible `Statistic`s the user can track.
//    enum Kind: String, CaseIterable {
////         MARK: Cases
//        /// The mean of the most recent `n` solves, excluding the fastest and slowest.
//        case average = "Average"
//        /// The mean of the most recent `n` solves.
//        case mean = "Mean"
//        /// The best time of the `Instance`.
//        case personalBest = "Personal Best"
//
////        // MARK: Properties
////        /// Stylized version of the statistic's name.
////        var formattedName: String {
////            return self.rawValue.capitalized
////        }
//    }
//
//    // MARK: Methods
//    /// Sets the `Statistic`'s corresponding instance.
//    mutating func setInstance(to instance: Instance) {
//        self.instance = instance
//    }
//}
//
//extension Statistic: Hashable {
//    // MARK: Methods
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(serialized)
//    }
//
//    static func == (lhs: Statistic, rhs: Statistic) -> Bool {
//        lhs.serialized == rhs.serialized
//    }
//}

import SwiftUI

/// Different statistics that an `Instance` can track.
enum Statistic: CaseIterable, Hashable {
    // MARK: Cases
    /// The mean of the most recent `n` solves, excluding the fastest and slowest.
    case average(Int)
    /// The mean of the most recent `n` solves.
    case mean(Int)
    /// The best time of the `Instance`.
    case personalBest

    // MARK: Properties
    /// All possible `Statistic`s.
    static var allCases: [Statistic] = [.average(5), .mean(5), .personalBest]

    /// Abbreviated version of the `Statistic`'s name.
    var shortName: String {
        switch self {
        case let .average(solves):
            return "ao\(solves)"
        case let .mean(solves):
            return "mo\(solves)"
        case .personalBest:
            return "pb"
        }
    }

    /// Full version of the `Statistic`'s name.
    var longName: String {
        switch self {
        case let .average(solves):
            return "Average of \(solves)"
        case let .mean(solves):
            return "Mean of \(solves)"
        case .personalBest:
            return "Personal Best"
        }
    }

    /// The system image on the button that performs the action.
    var actionSymbol: String? {
        switch self {
        case .average:
            return "trash"
        case .mean:
            return "trash"
        default:
            return nil
        }
    }

    /// Serialized `String` representation of the `Statistic`.
    var serialized: String {
        switch self {
        case let .average(solves):
            return "average:\(solves)"
        case let .mean(solves):
            return "mean:\(solves)"
        case .personalBest:
            return "personalBest"
        }
    }
    
    
    /// The name of the `Statistic`s kind with no associated value.
    var kindName: String {
        switch self {
        case .average:
            return "Average"
        case .mean:
            return "Mean"
        case .personalBest:
            return "Personal Best"
        }
    }
    
    /// The kind of the `Statistic`, not including associated values.
    var kind: Statistic {
        get {
            switch self {
            case .average:
                return .average(5)
            case .mean:
                return .mean(5)
            default:
                return self
            }
        }
        set {
            self = newValue
        }
    }

    // MARK: Initializers
    /// Creates a `Statistic` from a serialized `String`.
    init?(serialized: String) {
        let components = serialized.split(separator: ":")

        guard let first = components.first else {
            return nil
        }

        switch first {
        case "average":
            guard let second = components[safe: 1] else {
                return nil
            }

            guard let modifier = Int(second) else {
                return nil
            }

            self = .average(modifier)

        case "mean":
            guard let second = components[safe: 1] else {
                return nil
            }

            guard let modifier = Int(second) else {
                return nil
            }

            self = .mean(modifier)

        case "personalBest":
            self = .personalBest

        default:
            return nil
        }
    }
    
    // MARK: Methods
    /// Return the value of the statistic from an `Instance`.
    func value(of instance: Instance) -> String {
        switch self {
        case let .average(solves):
            return instance.formattedAverage(of: solves)
        case let .mean(solves):
            return instance.formattedMean(of: solves)
        case .personalBest:
            return Solve.formatTime(instance.unwrappedSolves.map { ($0 as? Solve)?.adjustedTime ?? 0 }.min())
        }
    }
    
    /// Returns the name of the SF Symbol of the `Statistic`.
    func symbol(of instance: Instance) -> String? {
        switch self {
        case let .average(solves):
            if instance.unwrappedSolves.count < solves + 1 {
                return nil
            }
            
            if instance.average(of: solves) ?? .greatestFiniteMagnitude < instance.average(indices: 1...solves) ?? .greatestFiniteMagnitude {
                return "chevron.up"
            } else if instance.average(of: solves) ?? .greatestFiniteMagnitude > instance.average(indices: 1...solves) ?? .greatestFiniteMagnitude {
                return "chevron.down"
            } else {
                return "equal"
            }
            
        case let .mean(solves):
            if instance.unwrappedSolves.count < solves + 1 {
                return nil
            }
            
            if instance.average(of: solves) ?? .greatestFiniteMagnitude < instance.average(indices: 1...solves) ?? .greatestFiniteMagnitude {
                return "chevron.up"
            } else if instance.average(of: solves) ?? .greatestFiniteMagnitude > instance.average(indices: 1...solves) ?? .greatestFiniteMagnitude {
                return "chevron.down"
            } else {
                return "equal"
            }
            
        default:
            return nil
        }
    }
    
    /// Returns the color of the SF Symbol of the `Statistic`.
    func symbolColor(of instance: Instance) -> Color? {
        switch self {
        case let .average(solves):
            if instance.unwrappedSolves.count < solves + 1 {
                return nil
            }
            
            if instance.average(of: solves) ?? .greatestFiniteMagnitude < instance.average(indices: 1...solves) ?? .greatestFiniteMagnitude {
                return .green
            } else if instance.average(of: solves) ?? .greatestFiniteMagnitude > instance.average(indices: 1...solves) ?? .greatestFiniteMagnitude {
                return .red
            } else {
                return .secondary
            }
            
        case let .mean(solves):
            if instance.unwrappedSolves.count < solves + 1 {
                return nil
            }
            
            if instance.average(of: solves) ?? .greatestFiniteMagnitude < instance.average(indices: 1...solves) ?? .greatestFiniteMagnitude {
                return .green
            } else if instance.average(of: solves) ?? .greatestFiniteMagnitude > instance.average(indices: 1...solves) ?? .greatestFiniteMagnitude {
                return .red
            } else {
                return .secondary
            }
            
        default:
            return nil
        }
    }
    
    /// Returns a list of details of an `Intsance` based on the statistic.
    func details(of instance: Instance) -> [String]? {
        switch self {
        case let .average(solves):
            let solves = instance.solveArray.suffix(solves)

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

        case let .mean(solves):
            return instance.solveArray.filter { $0.penalty != .dnf }.suffix(solves).map { Solve.formatTime($0.adjustedTime) }

        default:
            return nil
        }
    }
    
    /// Returns a closure to run on an `Instance` when a `detail` is pressed.
    func action(of instance: Instance) -> ((Int) -> Void)? {
        switch self {
        case .average:
            return { index in
                if instance.unwrappedSolves.count > index {
                    if instance.unwrappedSolves.count > index {
                        SolveStorage.delete(instance.solveArray.suffix(index + 1).first!)
                    }
                }
            }
            
        case .mean:
            return { index in
                if instance.unwrappedSolves.count > index {
                    if instance.unwrappedSolves.count > index {
                        SolveStorage.delete(instance.solveArray.suffix(index + 1).first!)
                    }
                }
            }
            
        default:
            return nil
        }
    }
}
