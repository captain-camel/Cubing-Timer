//
//  Algorithm.swift
//  Cubing Timer
//
//  Created by Cameron Delong on 8/13/21.
//

import OrderedCollections
import Foundation

/// A series of `Moves` forming an `Algorithm` that can be performed on a `Cube`.
struct Algorithm: Codable {
    // MARK: Properties
    /// A dictionary of various algorithms for a number of puzzles.
    static var algorithms: OrderedDictionary<String, OrderedDictionary<String, [(name: String, algorithms: [Algorithm], category: String, highlightedTiles: [Cube.Tile])]>> = [
        "3x3": [
            "2-look OLL": [
                ("Dot", ["F (R U R' U') F' f (R U R' U') f'"], "Edges", [.up]),
                ("I-Shape", ["F (R U R' U') F'", "(R U R' U') M' (U R U' r')"], "Edges", [.up]),
                ("L-Shape", ["f (R U R' U') f'", "y2 F (U R U' R') F'", "y2 (r U R' U') r' R (U R U' R')"], "Edges", [.up]),
                ("Antisune", ["(R U2 R' U') (R U' R')", "y' (R' U' R U') (R' U2 R)", "y (L' U' L U') (L' U2 L)"], "Corners", [.up]),
                ("H", ["(R U R' U) (R U' R' U) (R U2 R')", "y F (R U R' U') (R U R' U') (R U R' U') F'"], "Corners", [.up]),
                ("L", ["(F R' F' r) (U R U' r')"], "Corners", [.up]),
                ("Pi", ["R U2 (R2 U' R2 U' R2) U2 R"], "Corners", [.up]),
                ("Sune", ["(R U R' U) (R U2 R')", "y' R' U2 (R U R' U) R"], "Corners", [.up]),
                ("T", ["(r U R' U') (r' F R F')"], "Corners", [.up]),
                ("U", ["R2 D (R' U2 R) D' (R' U2 R')"], "Corners", [.up])
            ],
            "2-look PLL": [
                ("Diagonal", ["F (R U' R' U') (R U R') F' (R U R' U') (R' F R F')"], "Corners", Cube.Tile.allCases),
                ("Headlights", ["(R U R' U') R' F (R2 U' R' U') (R U R') F'"], "Corners", Cube.Tile.allCases),
                ("H", ["M2 U M2 U2 M2 U M2", "M2 U' M2 U2 M2 U' M2"], "Edges", Cube.Tile.allCases),
                ("Ua", ["R U' (R U R U) (R U' R' U') R2", "M2 U M U2 M' U M2"], "Edges", Cube.Tile.allCases),
                ("Ub", ["R2 U (R U R' U') (R' U' R' U) R'", "(L' U L' U') (L' U' L' U) L U L2", "M2 U' M U2 M' U' M2"], "Edges", Cube.Tile.allCases),
                ("Z", ["M' U (M2 U M2 U) M' U2 M2", "M' U' (M2 U' M2 U') M' U2 M2"], "Edges", Cube.Tile.allCases)
            ],
            "OLL": [
                ("1", ["(R U2 R') (R' F R F') U2 (R' F R F')"], "Dot", [.up]),
                ("2", ["(r U r' U2) (r U2 R' U2) (R U' r')", "y' F (R U R' U') F' f (R U R' U') f'", "y' F (R U R' U') S (R U R' U') f'"], "Dot", [.up]),
                ("3", ["r' (R2 U R' U) (r U2 r' U) M'", "y F (U R U' R') F' U F (R U R' U') F'", "y' f (R U R' U') f' U' F (R U R' U') F'"], "Dot", [.up]),
                ("4", ["M (U' r U2 r') (U' R U' R') M'", "y F (U R U' R') F' U' F (R U R' U') F'", "y' f (R U R' U') f' U F (R U R' U') F'"], "Dot", [.up]),
                ("5", ["(l' U2 L U) (L' U l)", "y2 (r' U2 R U) (R' U r)"], "Square Shape", [.up]),
                ("6", ["(r U2 R' U') (R U' r')"], "Square Shape", [.up]),
                ("7", ["(r U R' U) (R U2 r')"], "Small Lightning Bolt", [.up]),
                ("8", ["(l' U' L U') (L' U2 l)", "(R U2 R' U2) (R' F R F')", "y2 (r' U' R U') (R' U2 r)"], "Small Lightning Bolt", [.up]),
                ("9", ["(R U R' U') R' F (R2 U R' U') F'"], "Fish Shape", [.up]),
                ("10", ["(R U R' U) (R' F R F') (R U2 R')", "y2 (r U R' U) (R U' R' U') r' R (U R U' R')"], "Fish Shape", [.up]),
                ("11", ["(r U R' U) (R' F R F') (R U2 r')", "y2 r' (R2 U R' U) (R U2 R' U) M'"], "Small Lightning Bolt", [.up]),
                ("12", ["M' (R' U' R U') (R' U2 R U') R r'"], "Small Lightning Bolt", [.up]),
                ("13", ["F (U R U' R2) F' (R U R U') R'", "(r U' r' U') (r U r') y' (R' U R)"], "Knight Move Shape", [.up]),
                ("14", ["R' F (R U R') F' R F U' F'"], "Knight Move Shape", [.up]),
                ("15", ["(l' U' l) (L' U' L U) (l' U l)", "y2 (r' U' r) (R' U' R U) (r' U r)"], "Knight Move Shape", [.up]),
                ("16", ["(r U r') (R U R' U') (r U' r')"], "Knight Move Shape", [.up]),
                ("17", ["F R' F' R2 (r' U R U') R' U' M'", "y2 (R U R' U) (R' F R F') U2 (R' F R F')"], "Dot", [.up]),
                ("18", ["(r U R' U) (R U2 r') (r' U' R U') (R' U2 r)", "y (R U2 R') (R' F R F') U2 M' (U R U' r')"], "Dot", [.up]),
                ("19", ["r' (R U R U) R' U' M' (R' F R F')"], "Dot", [.up]),
                ("20", ["(r U R' U') M2 (U R U' R') U' M'", "r' R U (R U R' U') M2 (U R U' r')"], "Dot", [.up]),
                ("21", ["(R U2 R' U') (R U R' U') (R U' R')", "y (R U R' U) (R U' R' U) (R U2 R')"], "Cross", [.up]),
                ("22", ["R U2 (R2 U' R2 U' R2) U2 R"], "Cross", [.up]),
                ("23", ["R2 D' (R U2 R') D (R U2 R)", "y2 R2 D (R' U2 R) D' (R' U2 R')"], "Cross", [.up]),
                ("24", ["(r U R' U') (r' F R F')", "y (R U R) D (R' U' R) D' R2"], "Cross", [.up]),
                ("25", ["F' (r U R' U') r' F R", "y' R' F R B' R' F' R B"], "Cross", [.up]),
                ("26", ["(R U2 R') (U' R U' R')", "y' (R' U' R U') (R' U2 R)"], "Cross", [.up]),
                ("27", ["(R U R' U) (R U2 R')", "y' R' U2 (R U R' U) R"], "Cross", [.up]),
                ("28", ["(r U R' U') r' (R U R U') R'"], "Corners Oriented", [.up]),
                ("29", ["(R U R' U') (R U' R') F' U' F (R U R')"], "Awkward Shape", [.up]),
                ("30", ["F R' F (R2 U' R' U') (R U R') F2", "F U (R U2 R' U') (R U2 R' U') F'"], "Awkward Shape", [.up]),
                ("31", ["R' U' F (U R U' R') F' R"], "P Shape", [.up]),
                ("32", ["L U F' (U' L' U L) F L'", "y2 S (R U R' U') (R' F R f')"], "P Shape", [.up]),
                ("33", ["(R U R' U') (R' F R F')"], "T Shape", [.up]),
                ("34", ["R U (R2 U' R') F (R U R U') F'", "(R U R' U') B' (R' F R F') B"], "C Shapee", [.up]),
                ("35", ["(R U2 R') (R' F R F') (R U2 R')"], "Fish Shape", [.up]),
                ("36", ["(L' U' L U') (L' U L U) (L F' L' F)", "y2 (R' U' R U') (R' U R U) R B' R' B"], "W Shape", [.up]),
                ("37", ["(F R' F' R) (U R U' R')", "F (R U' R' U') (R U R') F'"], "Fish Shape", [.up]),
                ("38", ["(R U R' U) (R U' R' U') (R' F R F')"], "W Shape", [.up]),
                ("39", ["L F' (L' U' L U) F U' L'", "y2 R B' (R' U' R U) B U' R'"], "Big Lightning Bolt", [.up]),
                ("40", ["R' F (R U R' U') F' U R"], "Big Lightning Bolt", [.up]),
                ("41", ["(R U R' U) (R U2 R') F (R U R' U') F'"], "Awkward Shape", [.up]),
                ("42", ["(R' U' R U') (R' U2 R) F (R U R' U') F'"], "Awkward Shape", [.up]),
                ("43", ["F' (U' L' U L) F", "R' U' (F R' F' R) U R"], "P Shape", [.up]),
                ("44", ["F (U R U' R') F'", "y2 f (R U R' U') f'"], "P Shape", [.up]),
                ("45", ["F (R U R' U') F'"], "T Shape", [.up]),
                ("46", ["R' U' (R' F R F') U R"], "C Shape", [.up]),
                ("47", ["R' U' (R' F R F') (R' F R F') U R", "F' (L' U' L U) (L' U' L U) F", "y' F (U R U' R') F' (R U R' U) (R U2 R')"], "Small L Shape", [.up]),
                ("48", ["F (R U R' U') (R U R' U') F'"], "Small L Shape", [.up]),
                ("49", ["r U' r2 U r2 U (r2 U' r)"], "Small L Shape", [.up]),
                ("50", ["r' U r2 U' r2 U' (r2 U r')"], "Small L Shape", [.up]),
                ("51", ["F (U R U' R') (U R U' R') F'", "y2 f (R U R' U') (R U R' U') f'"], "I Shape", [.up]),
                ("52", ["(R U R' U) R U' B U' B' R'", "y2 R' F' U' F U' (R U R' U) R", "(R U R' U) R U' y (R U' R') F'"], "I Shape", [.up]),
                ("53", ["(l' U2 L U) (L' U' L U) (L' U l)", "y2 r' U2 (R U R' U') (R U R' U) r", "y (r' U' R U') (R' U R U') (R' U2 r)"], "Small L Shape", [.up]),
                ("54", ["(r U2 R' U') (R U R' U') (R U' r')", "y (r U R' U) (R U' R' U) (R U2 r')"], "Small L Shape", [.up]),
                ("55", ["R' F (R U R U') R2 F' (R2 U' R' U) (R U R')", "y R U2 (R2 U' R U') R' U2 F R F'"], "I Shape", [.up]),
                ("56", ["(r' U' r) (U' R' U R) (U' R' U R) (r' U r)", "(r U r') (U R U' R') (U R U' R') (r U' r')", "(r U r') (U R U' R') U R U' M' U' r'"], "I Shape", [.up]),
                ("57", ["(R U R' U') M' (U R U' r')"], "Corners Oriented", [.up])
            ],
            "PLL": [
                ("1", ["R R R"], "h", [.up])
            ]
        ],
        "4x4": [
            "Parity": [
                
            ]
        ]
    ]
    
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
                let layers = 0...Int.random(in: 0...size / 2)
                
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
