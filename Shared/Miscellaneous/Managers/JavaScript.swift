//
//  JavaScript.swift
//  JavaScript
//
//  Created by Cameron Delong on 9/12/21.
//

import JavaScriptCore

/// A `class` that can run Javascript code.
class JavaScript {
    // MARK: Properties
    /// Singleton instance of `JavaScript`
    static var shared = JavaScript()
    
    /// The `JSContext` to run the Javascript code.
    var context = JSContext()
    
    // MARK: Methods
    /// Executes Javascript code and returns its return.
    func execute(_ code: String) throws -> Any {
        context = JSContext()
        
        context?.evaluateScript(
            "var executeCode = function() { \(code) }"
        )
        
        let executeCode = context?.objectForKeyedSubscript("executeCode")
        
        guard let result = executeCode?.call(withArguments: [])?.toObject() else {
            if let error = context?.exception?.toString() {
                throw JavaScriptError.runtimeError(error)
            }
            
            throw JavaScriptError.typeError
        }
        
        return result
    }
    
    // MARK: Types
    /// `Error`s that can be thrown by `JavaScript`.
    enum JavaScriptError: Error {
        /// The Javascript code encountered a runtime error.
        case runtimeError(String)
        /// The Javascript code returned an unsupported type.
        case typeError
    }
}
