//
//  Array.swift
//  Cubing Timer
//
//  Created by Cameron Delong on 8/7/21.
//

extension Array where Element: BinaryInteger {
    /// The average value of all the items in the array.
    var mean: Double {
        if self.isEmpty {
            return 0.0
        } else {
            let sum = self.reduce(0, +)
            return Double(sum) / Double(self.count)
        }
    }
}

extension Array where Element: BinaryFloatingPoint {
    /// The average value of all the items in the array.
    var mean: Double {
        if self.isEmpty {
            return 0.0
        } else {
            let sum = self.reduce(0, +)
            return Double(sum) / Double(self.count)
        }
    }
}

extension Array where Element: BinaryFloatingPoint {
    /// Returns the `Array` with the largest and smallest `n` values removed.
    func removingOutliers(_ count: Int) -> [Element] {
        if count * 2 > self.count {
            return []
        }
        
        var elements = self
        
        for _ in 0..<count {
            elements.remove(at: elements.firstIndex(of: elements.max()!)!)
        }
        
        for _ in 0..<count {
            elements.remove(at: elements.firstIndex(of: elements.min()!)!)
        }
        
        return elements
    }
}

extension Array where Element: Equatable {
    /// Returns the provided value if it exists in the array, otherwise returns `nil`.
    func instance(of value: Element) -> Element? {
        if contains(value) {
            return value
        } else {
            return nil
        }
    }
}
