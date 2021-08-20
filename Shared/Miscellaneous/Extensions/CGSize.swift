//
//  CGSize.swift
//  Cubing Timer
//
//  Created by Cameron Delong on 8/20/21.
//

import CoreGraphics

extension CGSize {
    /// The distance from 0,0 of the point.
    var distance: CGFloat {
        return (pow(height, 2) + pow(width, 2)).squareRoot()
    }
}
