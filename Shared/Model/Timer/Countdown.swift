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
    @Published var isComplete = false
    /// Whether the `Countdown` is running.
    @Published var isRunning = false
    
    /// The number of seconds after the `Countdown` is started before it completes.
    let duration: Double
    
    /// A callback that is called when the `Countdown` completes.
    let completeAction: () -> Void
    
    /// The `Swift` `Timer` that determines when the `Countdown` should complete.
    private var timer = Foundation.Timer()
    
    // MARK: Initializers
    /// Creates a `Countdown` of a specified duration.
    init(duration: Double, completeAction: @escaping () -> Void) {
        self.duration = duration
        
        self.completeAction = completeAction
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
        if isRunning {
            throw CountdownError.alreadyRunning
        }
        
        timer = Foundation.Timer.scheduledTimer(withTimeInterval: duration, repeats: false) { _ in
            self.isComplete = true
            
            self.completeAction()
        }
        
        isRunning = true
    }
    
    /// Stops and resets the `Countdown`.
    func reset() throws {
        if !isRunning {
            throw CountdownError.notRunning
        }
        
        timer.invalidate()
        
        isComplete = false
        isRunning = false
    }
}
