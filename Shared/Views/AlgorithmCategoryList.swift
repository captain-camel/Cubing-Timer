//
//  AlgorithmCategoryList.swift
//  AlgorithmCategoryList
//
//  Created by Cameron Delong on 9/25/21.
//

import SwiftUI

/// A tab view with algorithms for various puzzles.
struct AlgorithmCategoryList: View {
    // MARK: Body
    var body: some View {
        List(Algorithm.algorithms.elements, id: \.key) { puzzle in
            Section(header: Text(puzzle.key)) {
                ForEach(puzzle.value.elements, id: \.key) { category in
                    NavigationLink(destination: AlgorithmList(category.value)) {
                        Text(category.key)
                    }
                }
            }
        }
        .navigationTitle("Algorithms")
    }
}

struct AlgorithmCategoryList_Previews: PreviewProvider {
    static var previews: some View {
        AlgorithmCategoryList()
    }
}
