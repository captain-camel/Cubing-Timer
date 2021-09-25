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
    let algorithms: OrderedDictionary<String, [[Algorithm]]>
    
    // MARK: Initializers
    init(_ algorithms: OrderedDictionary<String, [[Algorithm]]>) {
        self.algorithms = algorithms
    }
    
    // MARK: Body
    var body: some View {
        List(algorithms.elements, id: \.key) { section in
            Section(header: Text(section.key)) {
                ForEach(section.value, id: \.self) { algorithm in
                    Text(algorithm.description)
                }
            }
        }
    }
}
