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
    
    // MARK: Body
    var body: some View {
        VStack {
            Text(Solve.formatTime(stopwatch.secondsElapsed))
            Text(String(countdown.isRunning))
            Text(String(gestureState.id))
        }
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
                } else {
                    try? countdown.start()
                }
                
            case .moved:
                try? countdown.reset()
            }
        }
    }
}
