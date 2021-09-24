//
//  CubeTileView.swift
//  CubeTileView
//
//  Created by Cameron Delong on 9/23/21.
//

import SwiftUI

/// A view that displays a single tile of a cube.
struct CubeTileView: View {
    // MARK: Properties
    /// The tile displayed.
    let tile: Cube.Tile
    
    // MARK: Initializers
    init(_ tile: Cube.Tile) {
        self.tile = tile
    }
    
    // MARK: Body
    var body: some View {
        GeometryReader { geometry in
            Rectangle()
                .foregroundColor(tile.color)
                .cornerRadius(max(geometry.size.width, geometry.size.height) / 5)
        }
    }
}

struct CubeTileView_Previews: PreviewProvider {
    static var previews: some View {
        CubeTileView(.down)
    }
}
