//
//  CubeSideView.swift
//  CubeSideView
//
//  Created by Cameron Delong on 9/23/21.
//

import SwiftUI

/// A view that shows a side of a `Cube`.
struct CubeSideView: View {
    // MARK: Properties
    /// The `Cube` to display.
    let cube: Cube
    
    /// Which face of the `Cube` to display.
    let face: Cube.Tile
    
    /// Tiles to highlight on the cube.
    let highlightedTiles: [Cube.Tile]
    
    // MARK: Initializers
    init(_ cube: Cube, face: Cube.Tile = .up, highlightedTiles: [Cube.Tile] = Cube.Tile.allCases) {
        self.cube = cube
        self.face = face
        self.highlightedTiles = highlightedTiles
    }
    
    // MARK: Body
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: geometry.size.width / 50) {
                HStack(spacing: geometry.size.width / 50) {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: geometry.size.width / 12)
                    
                    ForEach(cube.cubeState[Cube.surroundingSides[face]!.0]!.tiles[0].reversed(), id: \.self) { tile in
                        CubeTileView(highlightedTiles.instance(of: tile))
                    }
                    
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: geometry.size.width / 12)
                }
                .frame(height: geometry.size.width / 12)
                
                ForEach(0..<cube.size, id: \.self) { row in
                    HStack(spacing: geometry.size.width / 50) {
                        CubeTileView(highlightedTiles.instance(of: cube.cubeState[Cube.surroundingSides[face]!.3]!.tiles[0][row]))
                            .frame(width: geometry.size.width / 12)
                        
                        ForEach(cube.cubeState[face]!.tiles[row], id: \.self) { tile in
                            CubeTileView(highlightedTiles.instance(of: tile))
                        }
                        
                        CubeTileView(highlightedTiles.instance(of: cube.cubeState[Cube.surroundingSides[face]!.1]!.tiles[0][cube.size - (row + 1)]))
                            .frame(width: geometry.size.width / 12)
                    }
                }
                
                HStack(spacing: geometry.size.width / 50) {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: geometry.size.width / 12)
                    
                    ForEach(cube.cubeState[Cube.surroundingSides[face]!.2]!.tiles[0], id: \.self) { tile in
                        CubeTileView(highlightedTiles.instance(of: tile))
                    }
                    
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: geometry.size.width / 12)
                }
                .frame(height: geometry.size.width / 12)
            }
            .aspectRatio(1, contentMode: .fit)
        }
    }
}

struct CubeSideView_Previews: PreviewProvider {
    static var shared = Self()
    
    var cube: Cube
    
    init() {
        cube = Cube()
        
        try! cube.applyAlgorithm("R U' R' F' U F R U R' U R U' R'")
    }
    
    static var previews: some View {
        CubeSideView(shared.cube)
            .frame(width: 100)
    }
}
