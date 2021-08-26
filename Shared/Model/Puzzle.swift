//
//  Puzzle.swift
//  Cubing Timer
//
//  Created by Cameron Delong on 8/5/21.
//

/// Any twisty puzzle.
enum Puzzle: CaseIterable, Hashable {
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
    /// All WCA puzzles and `.other`.
    static var allCases: [Puzzle] = (2...7).map { cube($0) } + [pyraminx, megaminx, skewb, square_1, other("")]
    
    /// Serialized `String` representing the `Puzzle`.
    var serialized: String {
        print(description + "<-")
        switch self {
        case .other:
            return "_\(description)"
        default:
            return ".\(description)"
        }
    }
    
    /// The name of the `Puzzle` to be displayed while creating a new `Instance`.
    var displayName: String {
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
            
        case .other:
            return "Other"
        }
    }
    
    /// A computed property to set the name of an `.other` `Puzzle`.
    var other: String {
        get {
            return String(self)
        }
        set {
            self = .other(newValue)
        }
    }
    
    /// The kind of the `Puzzle`, not including associated values.
    var kind: Puzzle {
        get {
            switch self {
            case .other:
                return .other("")
            default:
                return self
            }
        }
        set {
            self = newValue
        }
    }
    
    // MARK: Initializers
    /// Creates a `Puzzle` from a serialized `String`.
    init(serialized: String) {
        let name = String(serialized.dropFirst())
        
        if serialized.first == "_" {
            self = .other(name)
        } else {
            switch name {
            case _ where name.count == 3 && (Int(String(name.first!)) != nil) && (Int(String(name.last!)) != nil) && name[1] == "x":
                self = .cube(Int(String(name.first!))!)
            case "Pyraminx":
                self = .pyraminx
            case "Megaminx":
                self = .megaminx
            case "Skewb":
                self = .skewb
            case "Square-1":
                self = .square_1
                
            default:
                self = .other(name)
            }
        }
    }
}

extension Puzzle: LosslessStringConvertible {
    // MARK: Properties
    /// The `String` description of the `Puzzle`.
    var description: String {
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
    /// Creates a `Puzzle` from a `String`.
    init(_ description: String) {
        switch description {
        case _ where description.count == 3 && (Int(String(description.first!)) != nil) && (Int(String(description.last!)) != nil) && description[1] == "x":
            self = .cube(Int(String(description.first!))!)
        case "Pyraminx":
            self = .pyraminx
        case "Megaminx":
            self = .megaminx
        case "Skewb":
            self = .skewb
        case "Square-1":
            self = .square_1
            
        default:
            self = .other(description)
        }
    }
}

extension Puzzle: ExpressibleByStringLiteral {
    // MARK: Initializers
    init(stringLiteral value: String) {
        self.init(value)
    }
}
