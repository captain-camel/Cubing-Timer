//
//  AlgorithmList.swift
//  AlgorithmList
//
//  Created by Cameron Delong on 9/25/21.
//

import SwiftUI
import OrderedCollections

/// A list of algorithms of a specific category.
struct AlgorithmList: View {
    // MARK: Properties
    /// The algorithms to display.
    let algorithms: [(name: String, algorithms: [Algorithm], category: String?, highlightedTiles: [Cube.Tile])]
    
    /// The category of the `Algorithm`s.
    let category: String
    
    /// The `Puzzle` of the `Algorithm`s.
    let puzzle: Puzzle
    
    // MARK: Initializers
    init(_ algorithms: [(name: String, algorithms: [Algorithm], category: String?, highlightedTiles: [Cube.Tile])], category: String, puzzle: Puzzle) {
        self.algorithms = algorithms
        self.category = category
        self.puzzle = puzzle
    }
    
    // MARK: Body
    var body: some View {
        List(algorithms, id: \.algorithms) { algorithmSet in
            HStack {
                AlgorithmView(algorithmSet.algorithms, name: algorithmSet.name, category: algorithmSet.category, highlightedTiles: algorithmSet.highlightedTiles, puzzle: puzzle)
            }
        }
        .navigationTitle("\(puzzle.displayName) - \(category)")
    }
}
