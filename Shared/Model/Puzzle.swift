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
    static var allCases: [Puzzle] = (2...7).map { .cube($0) } + [.pyraminx, .megaminx, .skewb, .square_1, .other("")]
    
    /// Serialized `String` representing the `Puzzle`.
    var serialized: String {
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
    
    // MARK: Initializers
    /// Creates a `Puzzle` from a serialized `String`.
    init(serialized: String) {
        let name = String(serialized.dropFirst())
        
        if serialized.first == "_" {
            self = .other(name)
        } else {
            let components = name.components(separatedBy: "x")
            
            if components.count == 2, let firstPart = Int(components[0]), let secondPart = Int(components[1]), firstPart == secondPart { // If the string is in form of "NUMBERxNUMBER"
                self = .cube(firstPart)
            } else {
                switch name {
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
        case _ where description.allSatisfy { $0.isNumber || $0 == "x" } && description.split(separator: "x").count == 2:
            self = .cube(Int(description.split(separator: "x").first!) ?? 3)
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

extension Puzzle: Decodable {
    // MARK: Initializers
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)
        
        self.init(string)
    }
}
