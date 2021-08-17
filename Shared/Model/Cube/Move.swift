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
    
    /// A `String` representation of the `Move`.
    var stringValue: String {
        if layers == 0...0 {
            return face.rawValue
        } else if layers.count == 1 {
            return "\(layers.first! + 1)\(face.rawValue)\(direction.rawValue)"
        } else if layers.contains(0) {
            return "\(layers.max()! + 1)\(face.rawValue)w\(direction.rawValue)"
        } else {
            return "\(layers.upperBound)-\(layers.lowerBound)\(face.rawValue)\(direction.rawValue)"
        }
    }
    
    var reversed: Move {
        return try! Move(face: face, direction: direction.reversed, layers: layers)
    }
    
    // MARK: Initializers
    /// Creates an instance of `Move`.
    init(face: Cube.Tile, direction: Direction = .clockwise, layers: ClosedRange<Int> = 0...0) throws {
        if layers.isEmpty || layers.map({ $0 < 0 }).contains(true) {
            throw MoveError.invalidMoveLayers
        }
        
        self.face = face
        self.direction = direction
        self.layers = layers
    }
    
    /// Creates a `Move` from a `String`.
    init(from string: String) throws {
        var lowerBound = ""
        var upperBound = ""
        
        var foundSeparator = false
        
        for (index, character) in Array(string).enumerated() {
            if let number = Int(String(character)), Array(string)[0...index].allSatisfy({ Int(String($0)) != nil || $0 == "-" }) {
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
                } else if character == "M" {
                    face = .left
                    layers = 1...1
                } else if character == "E" {
                    face = .down
                    layers = 1...1
                } else if character == "S" {
                    face = .front
                    layers = 1...1
                }
            }
        }
        
        if (Int(lowerBound) == nil && lowerBound != "") || (Int(upperBound) == nil && upperBound != "") {
            throw MoveError.invalidMoveString
        }
        
        if (upperBound != "" && lowerBound != "") && Int(upperBound)! < Int(lowerBound)! {
            throw MoveError.invalidMoveString
        }
        
        if string.contains("w") {
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
        
        if string.contains("'") {
            direction = .counterClockwise
        } else if let lastCharacter = string.last {
            if lastCharacter == "2" {
                direction = .double
            } else {
                direction = .clockwise
            }
        } else {
            throw MoveError.invalidMoveString
        }
    }
    
    // MARK: Types
    /// Possible direction a `Move` can turn.
    enum Direction: String {
        case clockwise = ""
        case counterClockwise = "'"
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
    
    /// `Error`s that can be thrown by an `Algorithm`.
    enum MoveError: Error {
        /// Thrown when initializing a `Move` from an invalid string.
        case invalidMoveString
        /// Thrown when initializing a `Move` with invalid layers.
        case invalidMoveLayers
    }
}
