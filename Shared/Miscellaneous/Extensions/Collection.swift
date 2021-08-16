//
//  Collection.swift
//  Cubing Timer
//
//  Created by Cameron Delong on 8/8/21.
//

extension Collection where Indices.Iterator.Element == Index {
    subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
