//
//  Algorithm.swift
//  Cubing Timer
//
//  Created by Cameron Delong on 8/13/21.
//

import Foundation

/// A series of `Moves` forming an `Algorithm` that can be performed on a `Cube`.
struct Algorithm {
    // MARK: Properties
    /// A dictionary of various algorithms for a number of puzzles.

    static var algorithms: [AlgorithmCategory] {
        if  let path = Bundle.main.path(forResource: "Algorithms", ofType: "plist"), let xml = FileManager.default.contents(atPath: path) {
            return (try? PropertyListDecoder().decode([AlgorithmCategory].self, from: xml)) ?? []
        } else {
            return []
        }
    }
    
    /// The `Move`s making up the `Algorithm`.
    var moves: [Move] = []
    
    /// The locations of "triggers" in the `Algorithm`.
    var triggerIndices: [Int] = []
    
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
    
    // MARK: Methods
    /// Returns an `Algorithm` to scramble a `Puzzle`.
    static func scramble(puzzle: Puzzle) -> Self? {
        switch puzzle {
        case let .cube(size):
            var scramble = Algorithm()
            
            for _ in 1...size * 12 - 15 {
                let face: Cube.Tile
                let direction = Move.Direction.allCases.randomElement()!
                let layers = 0...Int.random(in: 0...(size / 2) - 1)
                
                if layers == scramble.moves.last?.layers {
                    face = Cube.Tile.allCases.filter { $0 != scramble.moves.last?.face }.randomElement()!
                } else {
                    face = Cube.Tile.allCases.randomElement()!
                }
                
                scramble.moves.append(
                    Move(
                        face: face,
                        direction: direction,
                        layers: layers
                    )!
                )
            }
            
            return scramble
            
        default:
            return nil
        }
    }
}

extension Algorithm: LosslessStringConvertible {
    // MARK: Properties
    /// A `String` describing of the `Algorithm`.
    var description: String {
        var elements: [String] = []
        
        var triggerCharacter = "("
        
        for (index, move) in moves.enumerated() {
            for _ in triggerIndices.filter({ $0 == index }) {
                elements.append(triggerCharacter)
                
                triggerCharacter = triggerCharacter == "(" ? ")" : "("
            }
            
            elements.append(String(move))
        }
        
        for _ in triggerIndices.filter({ $0 == moves.count }) {
            elements.append(triggerCharacter)
        }
        
        var description = ""
        
        for (index, element) in elements.enumerated() {
            description.append(element)
            
            if index != elements.endIndex - 1 && element != "(" && elements[safe: index + 1] != ")" {
                description.append(" ")
            }
        }
        
        return description
    }
    
    // MARK: Initializers
    /// Creates an `Algorithm` from a `String`.
    init(_ description: String) {
        let moves = description.split(separator: " ")
        
        var index = 0
        
        for move in moves {
            if move.first == "(" || move.first == ")" {
                triggerIndices.append(index)
            } else if move.last == "(" || move.last == ")" {
                triggerIndices.append(index + 1)
            }
            
            guard let toAppend = Move(String(move.filter { $0 != "(" && $0 != ")" })) else {
                continue
            }
            
            self.moves.append(toAppend)
            
            index += 1
        }
    }
    
    // MARK: Types
    /// A category of algorithms based on their `Puzzle`.
    struct AlgorithmCategory: Decodable {
        /// The `Puzzle` assigned to the category.
        var puzzle: Puzzle
        /// The subcategories in the category.
        var subcategories: [AlgorithmSubcategory]
    }

    /// A subcategory of algorithms based on their characteristics.
    struct AlgorithmSubcategory: Decodable {
        /// The name of the category.
        var name: String
        /// The algorithms in the category.
        var algorithmSets: [AlgorithmSet]
    }

    /// A set of algorithms to solve the same case.
    struct AlgorithmSet: Decodable {
        /// The name of the case solved by the algorithm.
        var name: String
        /// The different algorithms that solve this case.
        var algorithms: [Algorithm]
        /// The category of the case.
        var category: String?
        /// The tiles to highlight when displaying the case that the algorithms solve.
        var highlightedTiles: [Cube.Tile]
    }
}

extension Algorithm: ExpressibleByStringLiteral {
    // MARK: Initializers
    init(stringLiteral value: String) {
        self.init(value)
    }
}

extension Algorithm: ExpressibleByArrayLiteral {
    // MARK: Initializers
    init(arrayLiteral: Move...) {
        self.init(arrayLiteral)
    }
}

extension Algorithm: Hashable {
    // MARK: Methods
    func hash(into hasher: inout Hasher) {
        hasher.combine(moves)
    }
}

extension Algorithm: Decodable {
    // MARK: Initializers
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)
        
        self.init(string)
    }
}
