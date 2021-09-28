//
//  AlgorithmView.swift
//  AlgorithmView
//
//  Created by Cameron Delong on 9/24/21.
//

import SwiftUI

/// A view that displays an `Algorithm` with the cube it solves.
struct AlgorithmView: View {
    // MARK: Properties
    /// The `Algorithm` to display.
    let algorithms: [Algorithm]
    
    /// The name of the algorithm.
    let name: String
    
    /// The category of the algorithm.
    let category: String
    
    /// The `Cube` to display.
    var cube: Cube
    
    /// Tiles to highlight on the cube.
    let highlightedTiles: [Cube.Tile]
    
    /// The selected `Algorithm` out of `algorithms`.
    @AppStorage private var selectedAlgorithm: String
    
    // MARK: Initializers
    init(_ algorithm: Algorithm, name: String, category: String? = nil, highlightedTiles: [Cube.Tile] = Cube.Tile.allCases, puzzle: Puzzle = .cube(3)) {
        self.init([algorithm], name: name, category: category, highlightedTiles: highlightedTiles, puzzle: puzzle)
    }
    
    init(_ algorithms: [Algorithm], name: String, category: String? = nil, highlightedTiles: [Cube.Tile] = Cube.Tile.allCases, puzzle: Puzzle = .cube(3)) {
        self.algorithms = algorithms
        
        self.name = name
        
        if let unwrapped = category {
            self.category = " - \(unwrapped)"
        } else {
            self.category = ""
        }
        
        cube = Cube(puzzle: puzzle) ?? Cube()
        
        try? cube.applyAlgorithm((algorithms.first ?? "").reversed)
        
        _selectedAlgorithm = AppStorage(wrappedValue: String(algorithms.first ?? ""), algorithms.description)
        
        self.highlightedTiles = highlightedTiles
    }
    
    // MARK: Body
    var body: some View {
        HStack {
            CubeSideView(cube, highlightedTiles: highlightedTiles)
                .frame(width: 50, height: 50)
                .padding(.vertical, 5)
            
            VStack(alignment: .leading) {
                Text(name)
                    .bold() +
                Text(category)
                    .foregroundColor(.secondary)

                Text(selectedAlgorithm)
                    .foregroundColor(.secondary)
            }
            .padding(5)
            
            Spacer()
            
            Menu {
                ForEach(algorithms, id: \.self) { algorithm in
                    Button {
                        selectedAlgorithm = String(algorithm)
                    } label: {
                        if selectedAlgorithm == String(algorithm) {
                            Label(String(algorithm), systemImage: "checkmark")
                        } else {
                            Text(String(algorithm))
                        }
                    }
                }
            } label: {
                Image(systemName: "pencil")
            }
        }
    }
}

struct AlgorithmView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            AlgorithmView("M2 U' M U2 M' U' M2", name: "name", category: "category")
            
            AlgorithmView(["R", "R", "R"], name: "name")
        }
    }
}
