//
//  Stopwatch.swift
//  Cubing Timer
//
//  Created by Cameron Delong on 8/15/21.
//

import Foundation

/// A stopwatch that can be observed in a `SwiftUI` view.
class Stopwatch: ObservableObject {
    // MARK: Properties
    /// The numbers of seconds elapsed since the `Stopwatch` started.
    @Published var secondsElapsed = 0.0
    /// Whether the `Stopwatch` is running.
    @Published var isRunning = false
    
    /// The exaxt time that the timer started.
    private var startTime = Date()
    /// The `Swift` `Timer` that updates `secondsElapsed` every `0.1` seconds.
    private var timer = Foundation.Timer()
    
    // MARK: Types
    /// Errors that can be thrown by `Stopwatch`
    enum StopwatchError: Error {
        /// Thrown when `start()` is called if the `Stopwatch` is already running.
        case alreadyRunning
        /// Thrown when `stop()` is called if the `Stopwatch` isn't running.
        case notRunning
    }
    
    // MARK: Methods
    /// Starts the `Stopwatch`.
    func start() throws {
        if isRunning {
            throw StopwatchError.alreadyRunning
        }
        
        startTime = Date()
        
        timer = Foundation.Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            self.secondsElapsed = round(Date().timeIntervalSince(self.startTime) * 10) / 10
        }
        
        isRunning = true
    }
    
    /// Stops the `Stopwatch`.
    func stop() throws {
        if !isRunning {
            throw StopwatchError.notRunning
        }
        
        timer.invalidate()
        
        secondsElapsed = Date().timeIntervalSince(startTime)
        isRunning = false
    }
    
    /// Resets the `Stopwatch`.
    func reset() {
        secondsElapsed = 0
        startTime = Date()
    }
}
