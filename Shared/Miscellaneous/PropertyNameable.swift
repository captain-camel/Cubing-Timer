//
//  PropertyNameable.swift
//  Cubing Timer
//
//  Created by Cameron Delong on 11/12/21.
//

/// A class who's properties can be named using `name(of:)`.
protocol PropertyNameable: AnyObject {}

extension PropertyNameable {
    // MARK: Methods
    /// Returns the name of a property that is a part of this class as a `String`.
    func name(of property: AnyObject) -> String {
        let propertyAddress = Unmanaged.passUnretained(property).toOpaque() // Gets the memory address of the property
        let children = Mirror(reflecting: self).children
        let matchingChildName = children.filter { child in
            propertyAddress == Unmanaged.passUnretained(child.value as AnyObject).toOpaque() // Gets the child that has the same memory address as the property
        }.compactMap { $0.label }.first ?? ""
        
        return matchingChildName
    }
}
