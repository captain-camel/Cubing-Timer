//
//  Inspection.swift
//  Cubing Timer
//
//  Created by Cameron Delong on 8/15/21.
//

import Foundation

/// A class to time an inspection before a solve is started.
class Inspection: ObservableObject {
    // MARK: Properties
    /// The seconds remaining in the `Inspection`.
    @Published var secondsRemaining = 0
    
    /// The duration of the `Inspection`.
    let duration: Int
    
    /// Whether the `Inspection` is running.
    private var running = false
    /// The `Swift` `Timer` that updates `secondsRemaining` every second.
    private var timer = Foundation.Timer()
    
    // MARK: Initializers
    /// Creates an `Inspection` of a specified duration.
    init(duration: Int) {
        self.duration = duration
    }
    
    // MARK: Types
    /// Errors that can be thrown by `Countdown`.
    enum InspectionError: Error {
        /// Thrown when `start()` is called if the `Inspection` is already running.
        case alreadyRunning
        /// Thrown when `reset()` is called if the `Inspection` isn't running.
        case notRunning
    }
    
    // MARK: Methods
    /// Starts the `Inspection`.
    func start() throws {
        if running {
            throw InspectionError.alreadyRunning
        }
        
        secondsRemaining = duration
        
        timer = Foundation.Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.secondsRemaining -= 1
        }
        
        running = true
    }
    
    /// Stops and resets the `Inspection`.
    func reset() throws {
        if !running {
            throw InspectionError.notRunning
        }
        
        timer.invalidate()
        
        secondsRemaining = duration
        
        running = false
    }
}
