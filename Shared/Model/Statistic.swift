//
//  Statistic.swift
//  Cubing Timer
//
//  Created by Cameron Delong on 8/5/21.
//

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
    /// The number of solves in the `Instance`.
    case solveCount

    // MARK: Properties
    /// `Statistic`s that the user can chose in settings.
    static var allCases: [Statistic] = [.average(5), .mean(5), .personalBest, .solveCount]
    /// `Statistic`s shows in `InstanceDetailSheet`.
    static var defaultCases: [Statistic] = [.personalBest, .average(5), .average(12), .average(50), .average(100), .average(1000), .solveCount]

    /// Abbreviated version of the `Statistic`'s name.
    var shortName: String {
        switch self {
        case let .average(solves):
            return "ao\(solves)"
        case let .mean(solves):
            return "mo\(solves)"
        case .personalBest:
            return "pb"
        case .solveCount:
            return "solves:"
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
        case .solveCount:
            return "Total Solves"
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
        case .solveCount:
            return "solveCount"
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
        case .solveCount:
            return "Solve Count"
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
            
        case "solveCount":
            self = .solveCount

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
        case .solveCount:
            return String(instance.unwrappedSolves.count)
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
