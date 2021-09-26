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
    
    /// The selected `Algorithm` out of `algorithms`.
    @AppStorage private var selectedAlgorithm: Algorithm
    
    // MARK: Initializers
    init(_ algorithm: Algorithm, name: String, category: String? = nil) {
        self.algorithms = [algorithm]
        
        self.name = name
        
        if let unwrapped = category {
            self.category = " - \(unwrapped)"
        } else {
            self.category = ""
        }
        
        cube = Cube()!
        
        try? cube.applyAlgorithm(algorithm.reversed)
        
        _selectedAlgorithm = AppStorage(wrappedValue: algorithms.first ?? Algorithm(), algorithms.description)
    }
    
    init(_ algorithms: [Algorithm], name: String, category: String? = nil) {
        self.algorithms = algorithms
        
        self.name = name
        
        if let unwrapped = category {
            self.category = " - \(unwrapped)"
        } else {
            self.category = ""
        }
        
        cube = Cube()!
        
        try? cube.applyAlgorithm(algorithms.first?.reversed ?? "")
        
        _selectedAlgorithm = AppStorage(wrappedValue: algorithms.first ?? Algorithm(), algorithms.description)
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

                Text(String(selectedAlgorithm))
                    .foregroundColor(.secondary)
            }
            .padding(5)
            
            Spacer()
            
            Menu {
                ForEach(algorithms, id: \.self) { algorithm in
                    Button(String(algorithm)) {
                        selectedAlgorithm = algorithm
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
