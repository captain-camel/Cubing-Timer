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
    
    /// The reverse of the algorithm.
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
}

extension Algorithm: LosslessStringConvertible {
    // MARK: Properties
    /// A `String` describing of the `Algorithm`.
    var description: String {
        return moves.map { String($0) }.joined(separator: " ")
    }
    
    // MARK: Initializers
    /// Creates an `Algorithm` from a `String`.
    init?(_ description: String) {
        let moves = description.split(separator: " ")
        
        for move in moves {
            guard let toAppend = Move(String(move)) else {
                return nil
            }
            
            self.moves.append(toAppend)
        }
    }
}

extension Algorithm: ExpressibleByStringLiteral {
    // MARK: Initializers
    init(stringLiteral value: String) {
        self.init(value)!
    }
}

extension Algorithm: ExpressibleByArrayLiteral {
    // MARK: Initializers
    init(arrayLiteral: Move...) {
        self.init(arrayLiteral)
    }
}
