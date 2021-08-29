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

extension CGSize {
    /// Returns the `CGSize` with the width and height rounded.
    func rounded(places: Int = 0) -> Self {
        return CGSize(width: round(width * pow(10, CGFloat(places))) / pow(10, CGFloat(places)), height: round(height * pow(10, CGFloat(places))) / pow(10, CGFloat(places)))
    }
}
