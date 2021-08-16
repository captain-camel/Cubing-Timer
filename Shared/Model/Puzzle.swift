//
//  Puzzle.swift
//  Cubing Timer
//
//  Created by Cameron Delong on 8/5/21.
//

import Foundation

enum Puzzle: Hashable, CaseIterable {
    static var allCases: [Puzzle] = [_2x2, _3x3, _4x4, _5x5, _6x6, _7x7, .pyraminx, .megaminx, .skewb, .square_1, .other("")]
    
    // MARK: Cases
    /// A cube with 2 pieces on each edge.
    case _2x2
    /// A cube with 3 pieces on each edge.
    case _3x3
    /// A cube with 4 pieces on each edge.
    case _4x4
    /// A cube with 5 pieces on each edge.
    case _5x5
    /// A cube with 6 pieces on each edge.
    case _6x6
    /// A cube with 7 pieces on each edge.
    case _7x7
    
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
        get {
            switch self {
            case ._2x2:
                return "2x2"
            case ._3x3:
                return "3x3"
            case ._4x4:
                return "4x4"
            case ._5x5:
                return "5x5"
            case ._6x6:
                return "6x6"
            case ._7x7:
                return "7x7"
                
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
        set {
            switch newValue {
            case "2x2":
                self = ._2x2
            case "3x3":
                self = ._3x3
            case "4x4":
                self = ._4x4
            case "5x5":
                self = ._5x5
            case "6x6":
                self = ._6x6
            case "7x7":
                self = ._7x7
                
            case "Pyraminx":
                self = .pyraminx
            case "Megaminx":
                self = .megaminx
            case "Skewb":
                self = .skewb
            case "Square-1":
                self = .square_1
                
            default:
                self = .other(newValue)
            }
        }
    }
    
    /// The number of peices on each edge of the puzzle.
    var size: Int? {
        switch self {
        case ._2x2:
            return 2
        case ._3x3:
            return 3
        case ._4x4:
            return 4
        case ._5x5:
            return 5
        case ._6x6:
            return 6
        case ._7x7:
            return 7
            
        case .pyraminx:
            return nil
        case .megaminx:
            return nil
        case .skewb:
            return nil
        case .square_1:
            return nil
            
        case .other:
            return nil
        }
    }
    
    // MARK: Initializers
    /// Creates an instance of `Puzzle` from a serialized string.
    init(from stringValue: String) {
        switch stringValue {
        case "2x2":
            self = ._2x2
        case "3x3":
            self = ._3x3
        case "4x4":
            self = ._4x4
        case "5x5":
            self = ._5x5
        case "6x6":
            self = ._6x6
        case "7x7":
            self = ._7x7
            
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
    
    /// Creates an instance of an `n` x `n` `Puzzle` from the number of peices in each edge.
    init(size: Int) {
        switch size {
        case 2:
            self = ._2x2
        case 3:
            self = ._3x3
        case 4:
            self = ._4x4
        case 5:
            self = ._5x5
        case 6:
            self = ._6x6
        case 7:
            self = ._7x7
        default:
            self = .other("\(size)x\(size)")
        }
    }
}
