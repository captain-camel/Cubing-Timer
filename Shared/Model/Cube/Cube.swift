//
//  Cube.swift
//  Cubing Timer
//
//  Created by Cameron Delong on 8/10/21.
//

import SwiftUI

/// A struct describing an cube shaped twisty puzzle with the same number of pieces on each edge.
struct Cube {
    // MARK: Properties
    /// The state of all the tiles of the cube.
    var cubeState: CubeState
    
    /// The number of pieces on each edge of the `Cube`.
    let size: Int
    /// The `Puzzle` that the `Cube` represents.
    let puzzle: Puzzle
    
    /// A dictionary indicating how to rotate a `Cube`.
    private static var moveTable: [Tile: [(Tile, Face.Direction, Tile, Face.Direction)]] = [
         .up: [(.front, .up, .right, .up), (.right, .up, .back, .up), (.back, .up, .left, .up), (.left, .up, .front, .up)],
         .front: [(.up, .down, .left, .right), (.left, .right, .down, .up), (.down, .up, .right, .left), (.right, .left, .up, .down)],
         .right: [(.up, .right, .front, .right), (.front, .right, .down, .right), (.down, .right, .back, .left), (.back, .left, .up, .right)],
         .down: [(.front, .down, .left, .down), (.left, .down, .back, .down), (.back, .down, .right, .down), (.right, .down, .front, .down)],
         .back: [(.up, .up, .right, .right), (.right, .right, .down, .up), (.down, .up, .left, .left), (.left, .left, .up, .down)],
         .left: [(.up, .left, .back, .right), (.back, .right, .down, .left), (.down, .left, .front, .left), (.front, .left, .up, .left)]
    ]
    
    static var surroundingSides: [Tile: (Tile, Tile, Tile, Tile)] = [
        .up: (.back, .right, .front, .left),
        .front: (.up, .right, .down, .left),
        .right: (.up, .back, .down, .front),
        .down: (.front, .right, .back, .left),
        .back: (.up, .left, .down, .right),
        .left: (.up, .front, .down, .back),
    ]
    
    /// Creates a `Cube` of a specified size.
    init?(size: Int = 3) {
        if size <= 1 {
            return nil
        }
        
        cubeState = [
            .up: Face(tile: .up, size: size),
            .front: Face(tile: .front, size: size),
            .right: Face(tile: .right, size: size),
            .down: Face(tile: .down, size: size),
            .back: Face(tile: .back, size: size),
            .left: Face(tile: .left, size: size),
        ]
        
        self.size = size
        
        puzzle = Puzzle.cube(size)
    }
    
    init?(puzzle: Puzzle) {
        switch puzzle {
        case let .cube(size):
            self.size = size
        default:
            return nil
        }

        cubeState = [
            .up: Face(tile: .up, size: size),
            .front: Face(tile: .front, size: size),
            .right: Face(tile: .right, size: size),
            .down: Face(tile: .down, size: size),
            .back: Face(tile: .back, size: size),
            .left: Face(tile: .left, size: size),
        ]
        
        self.puzzle = puzzle
    }
    
    // MARK: Types
    typealias CubeState = [Tile: Face]
    
    /// A side of a `Cube`, or a single tile on the side of a `Cube`.
    enum Tile: String, CaseIterable, Codable {
        // MARK: Cases
        /// The "up" face of a `Cube`.
        case up = "U"
        /// The "front" face of a `Cube`.
        case front = "F"
        /// The "right" face of a `Cube`.
        case right = "R"
        /// The "down" face of a `Cube`.
        case down = "D"
        /// The "back" face of a `Cube`.
        case back = "B"
        /// The "left" face of a `Cube`.
        case left = "L"

        // MARK: Properties
        /// The color associated with the `Tile`.
        var color: Color {
            switch self {
            case .up:
                return .yellow
            case .front:
                return .blue
            case .right:
                return .red
            case .down:
                return Color(.systemGray5)
            case .back:
                return .green
            case .left:
                return .orange
            }
        }
        
        
        /// An emoji of the color associated with the `Tile`.
        var colorEmoji: String {
            switch self {
            case .up:
                return "🟨"
            case .front:
                return "🟦"
            case .right:
                return "🟥"
            case .down:
                return "⬛️"
            case .back:
                return "🟩"
            case .left:
                return "🟧"
            }
        }
    }

    /// A side of a `Cube` made up of `Tile`s.
    struct Face {
        // MARK: Properties
        /// The `Tile`s making up the `Face`.
        var tiles: [[Tile]]
        
        // MARK: Initializers
        /// Creates a `Face` with a specified size and populated with a specified `Tile`.
        init(tile: Tile, size: Int = 3) {
            tiles = [[Tile]](repeating: [Tile](repeating: tile, count: size), count: size)
        }

        // MARK: Types
        /// Specifies what side of a `Face` to `get` and `set` pieces from.
        enum Direction {
            /// The "left" side of a `Face`.
            case left
            /// The "right" side of a `Face`.
            case right
            /// The "up" side of a `Face`.
            case up
            /// The "down" side of a `Face`.
            case down
        }

        // MARK: Methods
        /// Returns a slice of a face in a specified `Direction` at a specified layer.
        func getSlice(_ direction: Direction, layer: Int = 0) -> [Tile] {
            switch direction {
            case .up:
                return tiles[layer]
            case .right:
                return tiles.map { $0.suffix(layer + 1).first! }
            case .down:
                return tiles.suffix(layer + 1).first!.reversed()
            case .left:
                return tiles.map { $0[layer] }.reversed()
            }
        }

        /// Sets a slice of a face in a specified `Direction` at a specified layer to a value.
        mutating func setSlice(_ direction: Direction, layer: Int = 0, value: [Tile]) {
            switch direction {
            case .up:
                tiles[layer] = value
            case .right:
                for index in 0..<tiles.count {
                    tiles[index][tiles.count - (layer + 1)] = value[index]
                }
            case .down:
                tiles[tiles.count - (layer + 1)] = value.reversed()
            case .left:
                for index in 0..<tiles.count {
                    tiles[index][layer] = value.reversed()[index]
                }
            }
        }

        /// Rotates all of a `Face`'s `Tile`s in a specified `Direction`.
        mutating func rotate(_ direction: Move.Direction) {
            switch direction {
            case .clockwise:
                let previousTiles = tiles
                for row in previousTiles.indices {
                    for column in tiles[row].indices {
                        tiles[column][tiles.count - (row + 1)] = previousTiles[row][column]
                    }
                }
                
            case .counterClockwise:
                let previousTiles = tiles
                for row in previousTiles.indices {
                    for column in tiles[row].indices {
                        tiles[tiles.count - (column + 1)][row] = previousTiles[row][column]
                    }
                }
                
            case .double:
                tiles = tiles.map { $0 .reversed() }.reversed()
            }
        }
    }

    /// `Error`s that can be thrown by a `Cube`.
    enum CubeError: Error {
        /// Thrown when an invalid `Move` is applied to a `Cube`.
        case invalidMove
        /// Thrown when an invalid `Algorithm` is applied to a `Cube`.
        case invalidAlgorithm
        /// Thrown when a cube is initialized with an invalid size.
        case invalidSize
        /// Thrown when a cube is initialized from a non cube puzzle.
        case invalidPuzzle
    }

    // MARK: Methods
    /// Applies a `Move` to the `Cube`.
    mutating func applyMove(_ move: Move) throws {
        if !move.layers.allSatisfy((0..<size).contains) {
            throw CubeError.invalidMove
        }
        
        var previousCubeState = cubeState
        
        if move.layers.contains(0) {
            cubeState[move.face]!.rotate(move.direction)
        }
        
        if move.direction == .clockwise {
            for layer in move.layers {
                for value in Self.moveTable[move.face]! {
                    cubeState[value.0]!.setSlice(value.1, layer: layer, value: previousCubeState[value.2]!.getSlice(value.3, layer: layer))
                }
            }
        } else {
            for layer in move.layers {
                for value in Self.moveTable[move.face]! {
                    cubeState[value.2]!.setSlice(value.3, layer: layer, value: previousCubeState[value.0]!.getSlice(value.1, layer: layer))
                }
            }
        }
        
        previousCubeState = cubeState
        
        if move.direction == .double {
            for layer in move.layers {
                for value in Self.moveTable[move.face]! {
                    cubeState[value.2]!.setSlice(value.3, layer: layer, value: previousCubeState[value.0]!.getSlice(value.1, layer: layer))
                }
            }
        }
    }
    
    /// Applies an `Algorithm` to the `Cube`.
    mutating func applyAlgorithm(_ algorithm: Algorithm) throws {
        for move in algorithm.moves {
            do {
                try applyMove(move)
            } catch {
                throw CubeError.invalidAlgorithm
            }
        }
    }
    
    /// Prints the state of the `Cube`.
    func printState(colored: Bool = false) {
        for row in (0..<size).reversed() {
            print(
                String(repeating: colored ? "◻️" : " ", count: size),
                cubeState[.back]!.tiles[row].map { colored ? $0.colorEmoji : $0.rawValue }.reversed().joined(),
                String(repeating: colored ? "◻️" : " ", count: size * 2),
                separator: ""
            )
        }
        
        for row in 0..<size {
            print(
                cubeState[.left]!.tiles.map { colored ? $0[row].colorEmoji : $0[row].rawValue }.reversed().joined(),
                cubeState[.up]!.tiles[row].map { colored ? $0.colorEmoji : $0.rawValue }.joined(),
                cubeState[.right]!.tiles.map { colored ? $0.reversed()[row].colorEmoji : $0.reversed()[row].rawValue }.joined(),
                cubeState[.down]!.tiles.reversed()[row].map { colored ? $0.colorEmoji : $0.rawValue }.reversed().joined(),
                separator: ""
            )
        }
        
        for row in 0..<size {
            print(
                String(repeating: colored ? "◻️" : " ", count: size),
                cubeState[.front]!.tiles[row].map { colored ? $0.colorEmoji : $0.rawValue }.joined(),
                String(repeating: colored ? "◻️" : " ", count: size * 2),
                separator: ""
            )
        }
    }
}
