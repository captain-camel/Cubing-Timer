//
//  Countdown.swift
//  Cubing Timer
//
//  Created by Cameron Delong on 8/15/21.
//

import Foundation

/// A countdown that completes in a specified amount of time.
class Countdown: ObservableObject {
    // MARK: Properties
    /// Whether the `duration` has passed since the `Countdown` was started.
    @Published var complete = false
    /// Whether the `Countdown` is running.
    @Published var running = false
    
    /// The number of seconds after the `Countdown` is started before it completes.
    let duration: Double

    /// The `Timer` that determines when the `Countdown` should complete.
    private var timer = Foundation.Timer()
    
    // MARK: Initializers
    /// Creates a `Countdown` of a specified duration.
    init(duration: Double) {
        self.duration = duration
    }
    
    // MARK: Types
    /// Errors that can be thrown by `Countdown`.
    enum CountdownError: Error {
        /// Thrown when `start()` is called if the `Countdown` is already running.
        case alreadyRunning
        /// Thrown when `reset()` is called if the `Countdown` isn't running.
        case notRunning
    }
    
    // MARK: Methods
    /// Starts the `Countdown`.
    func start() throws {
        if running {
            throw CountdownError.alreadyRunning
        }
        
        timer = Foundation.Timer.scheduledTimer(withTimeInterval: duration, repeats: false) { _ in
            self.complete = true
        }
        
        running = true
    }
    
    /// Stops and resets the `Countdown`.
    func reset() throws {
        if !running {
            throw CountdownError.notRunning
        }
        
        timer.invalidate()
        
        complete = false
        running = false
    }
}
