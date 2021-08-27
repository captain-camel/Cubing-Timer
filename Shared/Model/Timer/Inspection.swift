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
    @Published var secondsRemaining: Int
    
    /// The duration of the `Inspection`.
    var duration: Int {
        didSet {
            secondsRemaining = duration
        }
    }
    
    /// Whether the `Inspection` is running.
    private var running = false
    /// The exaxt time that the timer started.
    private var startTime = Date()
    /// The `Timer` that updates `secondsRemaining` every second.
    private var timer = Timer()
    
    // MARK: Initializers
    /// Creates an `Inspection` of a specified duration.
    init(duration: Int) {
        self.duration = duration
        
        self.secondsRemaining = duration
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
        
        startTime = Date()

        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
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
