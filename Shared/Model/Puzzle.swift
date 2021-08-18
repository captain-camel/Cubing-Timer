//
//  Puzzle.swift
//  Cubing Timer
//
//  Created by Cameron Delong on 8/5/21.
//

import Foundation

/// Any twisty puzzle.
enum Puzzle: Hashable, CaseIterable {
    static var allCases: [Puzzle] = (2...7).map { cube($0) } + [pyraminx, megaminx, skewb, square_1, other("")]
    
    // MARK: Cases
    /// A cube with the same number of pieces on each edge.
    case cube(Int)

    /// A tetrahedron with 3 pieces on each edge.
    case pyraminx
    /// A dodecahedron with 3 pieces on each edge.
    case megaminx
    /// A cube that rotates around its corners.
    case skewb
    /// A complex shape shifting cube.
    case square_1
    
    /// Some other puzzle that is not listed.
    case other(String)
    
    // MARK: Properties
    /// Formatted name of the puzzle.
    var stringValue: String {
        switch self {
        case let .cube(size):
            return "\(size)x\(size)"
            
        case .pyraminx:
            return "Pyraminx"
        case .megaminx:
            return "Megaminx"
        case .skewb:
            return "Skewb"
        case .square_1:
            return "Square-1"
            
        case let .other(name):
            return name
        }
    }
    
    // MARK: Initializers
    /// Creates an instance of `Puzzle` from a serialized string.
    init(from stringValue: String) {
        switch stringValue {
        case _ where stringValue.count == 3 && (Int(String(stringValue.first!)) != nil) && (Int(String(stringValue.last!)) != nil) && stringValue[1] == "x":
            self = .cube(Int(String(stringValue.first!))!)
        case "Pyraminx":
            self = .pyraminx
        case "Megaminx":
            self = .megaminx
        case "Skewb":
            self = .skewb
        case "Square-1":
            self = .square_1
            
        default:
            self = .other(stringValue)
        }
    }
}

extension Puzzle: ExpressibleByStringLiteral {
    init(stringLiteral value: String) {
        self.init(from: value)
    }
}
