//
//  TimerView.swift
//  Cubing Timer
//
//  Created by Cameron Delong on 8/16/21.
//

import SwiftUI

struct TimerView: View {
    // MARK: Properties
    /// The state of the timer.
    @Binding var timerState: TimerState

    /// A callback that is called when a the timer is stopped, with the time on the timer.
    let timerStoppedAction: (_ time: Double) -> Void

    /// A stopwatch to time solves.
    @StateObject var stopwatch = Stopwatch()
    /// A countdown to start timing solves.
    @StateObject var countdown = Countdown(duration: 0.5)
    /// A timer for inspection.
    @StateObject var inspection = Inspection(duration: 15)
    
    /// The displayed time.
    private var time: String {
        if timerState == .ready {
            return "0.0"
        } else if timerState == .running {
            return Solve.formatTime(stopwatch.secondsElapsed, places: 1)
        } else {
            return Solve.formatTime(stopwatch.secondsElapsed)
        }
    }
    
    /// The color of the timer text.
    private var timeColor: Color {
        if timerState == .running || timerState == .ready {
            return .white
        } else if timerState == .counting {
            return .yellow
        } else {
            return .primary
        }
    }

    // MARK: Initializers
    init(timerState: Binding<TimerState>, timerStoppedAction: @escaping (_ time: Double) -> Void) {
        self._timerState = timerState
        
        self.timerStoppedAction = timerStoppedAction
    }
    
    // MARK: Body
    var body: some View {
        Text(time)
            .font(.system(size: 100, design: .monospaced))
            .minimumScaleFactor(0.01)
            .lineLimit(1)
            .padding(.horizontal)
            .foregroundColor(.white)
            .colorMultiply(timeColor)
            .animation(.easeInOut, value: timeColor)
            .onChange(of: countdown.isComplete) { isComplete in
                if isComplete {
                    timerState = .ready
                }
            }
            .onChange(of: timerState) { [timerState] newValue in
                switch newValue {
                case .stopped:
                    if timerState == .running {
                        try? stopwatch.stop()

                        timerStoppedAction(stopwatch.secondsElapsed)
                    } else {
                        try? countdown.reset()
                    }
                case .counting:
                    try? countdown.start()
                case .running:
                    try? stopwatch.start()
                    
                    try? countdown.reset()
                default:
                    break
                }
            }
    }
    
    /// Possible states of a `TimerView`.
    enum TimerState {
        /// The timer is stopped.
        case stopped
        /// The timer is counting until it's ready.
        case counting
        /// Inspection is being counted
        case inspection
        /// The timer is ready to start.
        case ready
        /// The timer is running
        case running
    }
}
