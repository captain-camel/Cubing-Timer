//
//  TimerView.swift
//  Cubing Timer
//
//  Created by Cameron Delong on 8/16/21.
//

import SwiftUI

struct TimerView: View {
    // MARK: Properties
    /// A stopwatch to time solves.
    @ObservedObject var stopwatch = Stopwatch()
    /// A countdown to start timing solves.
    @ObservedObject var countdown = Countdown(duration: 0.5)
    /// A timer for inspection.
    @ObservedObject var inspection = Inspection(duration: 15)
    
    /// A binding to a `GestureState` to determine when to start and stop the timer.
    @Binding var gestureState: InstanceView.GestureState {
        didSet {
            switch gestureState {
            case .none:
                if countdown.isComplete {
                    try? stopwatch.start()
                }
                
                try? countdown.reset()
            case .stationary:
                if stopwatch.isRunning {
                    try? stopwatch.stop()
                } else {
                    try? countdown.start()
                }
                
            case .moved:
                try? countdown.reset()
            }
        }
    }
    
    /// The most recently recorded solve.
    var solve: Solve?
    
    /// A callback that is called when a the timer is stopped, with the time on the timer.
    let timerStopped: ((_ time: Double) -> Void)
    
    /// The displayed time.
    var time: String {
        if countdown.isComplete {
            return "0.0"
        } else if stopwatch.isRunning {
            return Solve.formatTime(stopwatch.secondsElapsed, places: 1)
        } else {
            return Solve.formatTime(solve?.time ?? 0)
        }
    }
    
    // MARK: Body
    var body: some View {
        Text(time)
        .font(.system(size: 100, design: .monospaced))
        .onChange(of: gestureState.id) { _ in
            switch gestureState {
            case .none:
                if countdown.isComplete {
                    try? stopwatch.start()
                }
                
                try? countdown.reset()
            case .stationary:
                if stopwatch.isRunning {
                    try? stopwatch.stop()
                    
                    timerStopped(stopwatch.secondsElapsed)
                } else {
                    try? countdown.start()
                }
                
            case .moved:
                try? countdown.reset()
            }
        }
    }
}
