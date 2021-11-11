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
        List(Algorithm.algorithms, id: \.puzzle) { puzzle in
            Section(header: Text(puzzle.puzzle.displayName)) {
                ForEach(puzzle.subcategories, id: \.name) { category in
                    NavigationLink(destination: AlgorithmList(category.algorithmSets, category: category.name, puzzle: puzzle.puzzle)) {
                        Text(category.name)
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
