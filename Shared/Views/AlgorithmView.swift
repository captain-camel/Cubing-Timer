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
    let algorithm: Algorithm
    
    /// The name of the algorithm.
    let name: String
    
    /// The category of the algorithm.
    let category: String
    
    /// The `Cube` to display.
    var cube: Cube
    
    // MARK: Initializers
    init(_ algorithm: Algorithm, name: String, category: String? = nil) {
        self.algorithm = algorithm
        
        self.name = name
        
        if let unwrapped = category {
            self.category = " - \(unwrapped)"
        } else {
            self.category = ""
        }
        
        cube = Cube()!
        
        try? cube.applyAlgorithm(algorithm.reversed)
    }
    
    // MARK: Body
    var body: some View {
        HStack {
            CubeSideView(cube)
                .frame(width: 50, height: 50)
                .padding(.vertical, 5)
            
            VStack(alignment: .leading) {
                Text(name)
                    .bold() +
                Text(category)
                    .foregroundColor(.secondary)
                
                Text(String(algorithm))
                    .foregroundColor(.secondary)
            }
            .padding(5)
        }
    }
}

struct AlgorithmView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            AlgorithmView("M2 U' M U2 M' U' M2", name: "name", category: "category")
            
            AlgorithmView(Algorithm("F R U' R' U' R U R' F' R U R' U' R' F R F'").reversed, name: "name")

        }
    }
}
