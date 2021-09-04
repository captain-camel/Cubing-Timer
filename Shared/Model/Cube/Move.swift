//
//  Move.swift
//  Cubing Timer
//
//  Created by Cameron Delong on 8/13/21.
//

/// A turn that can be performed on a `Cube`.
struct Move {
    // MARK: Properties
    /// The face that the `Move` acts on.
    var face: Cube.Tile = .up
    /// The `Direction` of the turn.
    var direction: Direction = .clockwise
    /// The layers to be rotated.
    var layers: ClosedRange<Int> = 0...0
    
    /// The reverse of the move.
    var reversed: Move {
        return Move(face: face, direction: direction.reversed, layers: layers)!
    }
    
    // MARK: Initializers
    /// Creates an instance of `Move`.
    init?(face: Cube.Tile, direction: Direction = .clockwise, layers: ClosedRange<Int> = 0...0) {
        if layers.isEmpty || layers.map({ $0 < 0 }).contains(true) {
            return nil
        }
        
        self.face = face
        self.direction = direction
        self.layers = layers
    }
    
    // MARK: Types
    /// Possible direction a `Move` can turn.
    enum Direction: String {
        /// Rotating a face clockwise.
        case clockwise = ""
        /// Rotating a face counterclockwise.
        case counterClockwise = "'"
        /// Rotating a face twice.
        case double = "2"
        
        var reversed: Direction {
            switch self {
            case .clockwise:
                return .counterClockwise
            case .counterClockwise:
                return .clockwise
            case .double:
                return .double
            }
        }
    }
    
    /// `Error`s that can be thrown by a `Move`.
    enum MoveError: Error {
        /// Thrown when initializing a `Move` with invalid layers.
        case invalidMoveLayers
    }
    
    // MARK: Methods
    /// Returns the `String` description of the `Move`
    func getDescription(as puzzle: Puzzle = .cube(3)) -> String {
        if layers == 0...0 {
            return face.rawValue
        } else if layers == 0...1 {
            return face.rawValue.lowercased()
        } else if layers == 1...1 && puzzle == .cube(3) {
            switch face {
            case .up, .down:
                return "E"
            case .front, .back:
                return "S"
            case .right, .left:
                return "M"
            }
        } else if layers.count == 1 {
            return "\(layers.first! + 1)\(face.rawValue)\(direction.rawValue)"
        } else if layers.contains(0) {
            return "\(layers.max()! + 1)\(face.rawValue)w\(direction.rawValue)"
        } else {
            return "\(layers.upperBound)-\(layers.lowerBound)\(face.rawValue)\(direction.rawValue)"
        }
    }
}

extension Move: LosslessStringConvertible {
    // MARK: Properties
    /// A `String`describing of the `Move`.
    var description: String {
        return getDescription()
    }
    
    // MARK: Initializers
    /// Creates a `Move` from a `String`.
    init?(_ description: String) {
        var lowerBound = ""
        var upperBound = ""
        
        var foundSeparator = false
        
        for (index, character) in Array(description).enumerated() {
            if let number = Int(String(character)), Array(description)[0...index].allSatisfy({ Int(String($0)) != nil || $0 == "-" }) {
                if !foundSeparator {
                    lowerBound += String(number)
                } else {
                    upperBound += String(number)
                }
            } else if character == "-" {
                foundSeparator = true
            }
            
            if character.isLetter {
                if let face = Cube.Tile(rawValue: String(character).uppercased()) {
                    self.face = face
                    
                    if character.isLowercase {
                        layers = 0...1
                    }
                } else if character == "E" {
                    face = .up
                    layers = 1...1
                } else if character == "S" {
                    face = .front
                    layers = 1...1
                } else if character == "M" {
                    face = .right
                    layers = 1...1
                }
            }
        }
        
        if (Int(lowerBound) == nil && lowerBound != "") || (Int(upperBound) == nil && upperBound != "") {
            return nil
        }
        
        if (upperBound != "" && lowerBound != "") && Int(upperBound)! < Int(lowerBound)! {
            return nil
        }
        
        if description.contains("w") {
            layers = 0...(Int(lowerBound) ?? 0)
        } else if lowerBound != "" {
            if lowerBound == "" {
                lowerBound = "0"
                upperBound = "0"
            } else if upperBound == "" {
                upperBound = lowerBound
            }
            layers = Int(lowerBound)! - 1...Int(upperBound)! - 1
        }
        
        if description.contains("'") {
            direction = .counterClockwise
        } else if let lastCharacter = description.last {
            if lastCharacter == "2" {
                direction = .double
            } else {
                direction = .clockwise
            }
        } else {
            return nil
        }
    }
}

extension Move: ExpressibleByStringLiteral {
    // MARK: Initializers
    init(stringLiteral value: String) {
        self.init(value)!
    }
}
