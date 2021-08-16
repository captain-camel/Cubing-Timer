//
//  Algorithm.swift
//  Cubing Timer
//
//  Created by Cameron Delong on 8/13/21.
//

/// A series of `Moves` forming an `Algorithm` that can be performed on a `Cube`.
struct Algorithm {
    // MARK: Properties
    /// The `Move`s making up the `Algorithm`.
    var moves: [Move] = []

    /// A `String` representation of the `Algorithm`.
    var stringValue: String {
        return moves.map { $0.stringValue }.joined(separator: " ")
    }
    
    var reversed: Algorithm {
        return Algorithm(moves.reversed().map { $0.reversed })
    }

    // MARK: Initializers
    /// Creates an `Algorithm` from a series of `Move`s.
    init(_ moves: Move...) {
        self.moves = moves
    }
    
    /// Creates an `Algorithm` from an array of `Move`s.
    init(_ moves: [Move]) {
        self.moves = moves
    }

    /// Creates an `Algorithm` from a `String`.
    init(from string: String) throws {
        let moves = string.split(separator: " ")
        
        for move in moves {
            guard let toAppend = try? Move(from: String(move)) else {
                throw AlgorithmError.invalidAlgorithmString
            }
            
            self.moves.append(toAppend)
        }
    }
    
    // MARK: Types
    /// `Error`s that can be thrown by an `Algorithm`.
    enum AlgorithmError: Error {
        /// Thrown when initializing an `Algorithm` from an invalid string.
        case invalidAlgorithmString
    }
}
