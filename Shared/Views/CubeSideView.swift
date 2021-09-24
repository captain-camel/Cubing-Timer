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
    
    // MARK: Initializers
    init(_ cube: Cube, face: Cube.Tile = .up) {
        self.cube = cube
        self.face = face
    }
    
    // MARK: Body
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: geometry.size.width / 50) {
                HStack(spacing: geometry.size.width / 50) {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: geometry.size.width / 12)
                    CubeTileView(cube.cubeState[Cube.surroundingSides[face]!.0]!.tiles[0][2])
                    CubeTileView(cube.cubeState[Cube.surroundingSides[face]!.0]!.tiles[0][1])
                    CubeTileView(cube.cubeState[Cube.surroundingSides[face]!.0]!.tiles[0][0])
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: geometry.size.width / 12)
                }
                .frame(height: geometry.size.width / 12)
                
                HStack(spacing: geometry.size.width / 50) {
                    CubeTileView(cube.cubeState[Cube.surroundingSides[face]!.3]!.tiles[0][0])
                        .frame(width: geometry.size.width / 12)
                    CubeTileView(cube.cubeState[face]!.tiles[0][0])
                    CubeTileView(cube.cubeState[face]!.tiles[0][1])
                    CubeTileView(cube.cubeState[face]!.tiles[0][2])
                    CubeTileView(cube.cubeState[Cube.surroundingSides[face]!.1]!.tiles[0][2])
                        .frame(width: geometry.size.width / 12)
                }
                
                HStack(spacing: geometry.size.width / 50) {
                    CubeTileView(cube.cubeState[Cube.surroundingSides[face]!.3]!.tiles[0][1])
                        .frame(width: geometry.size.width / 12)
                    CubeTileView(cube.cubeState[face]!.tiles[1][0])
                    CubeTileView(cube.cubeState[face]!.tiles[1][1])
                    CubeTileView(cube.cubeState[face]!.tiles[1][2])
                    CubeTileView(cube.cubeState[Cube.surroundingSides[face]!.1]!.tiles[0][1])
                        .frame(width: geometry.size.width / 12)
                }
                
                HStack(spacing: geometry.size.width / 50) {
                    CubeTileView(cube.cubeState[Cube.surroundingSides[face]!.3]!.tiles[0][2])
                        .frame(width: geometry.size.width / 12)
                    CubeTileView(cube.cubeState[face]!.tiles[2][0])
                    CubeTileView(cube.cubeState[face]!.tiles[2][1])
                    CubeTileView(cube.cubeState[face]!.tiles[2][2])
                    CubeTileView(cube.cubeState[Cube.surroundingSides[face]!.1]!.tiles[0][0])
                        .frame(width: geometry.size.width / 12)
                }
                
                HStack(spacing: geometry.size.width / 50) {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: geometry.size.width / 12)
                    CubeTileView(cube.cubeState[Cube.surroundingSides[face]!.2]!.tiles[0][0])
                    CubeTileView(cube.cubeState[Cube.surroundingSides[face]!.2]!.tiles[0][1])
                    CubeTileView(cube.cubeState[Cube.surroundingSides[face]!.2]!.tiles[0][2])
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
        cube = Cube()!
        
        try! cube.applyAlgorithm("R U' R' F' U F R U R' U R U' R'")
    }
    
    static var previews: some View {
        CubeSideView(shared.cube)
            .frame(width: 100)
    }
}
