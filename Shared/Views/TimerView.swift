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
    @StateObject var countdown: Countdown
    /// A timer for inspection.
    @StateObject var inspection: Inspection
    
    /// The displayed time.
    private var time: String {
        if timerState == .ready {
            return "0.0"
        } else if timerState == .inspection {
            return Solve.formatTime(Double(inspection.secondsRemaining), places: 0)
        } else if timerState == .running {
            return Solve.formatTime(stopwatch.secondsElapsed, places: 1)
        } else {
            return Solve.formatTime(stopwatch.secondsElapsed)
        }
    }
    
    /// The color of the timer text.
    private var timeColor: Color {
        if timerState == .running || timerState == .ready || timerState == .inspection {
            return .white
        } else if timerState == .counting {
            return .yellow
        } else {
            return .primary
        }
    }

    // MARK: Initializers
    init(timerState: Binding<TimerState>, countdownDuration: Double = 0.5, inspectionDuration: Int = 15, timerStoppedAction: @escaping (_ time: Double) -> Void) {
        self._timerState = timerState
        
        _countdown = StateObject(wrappedValue: Countdown(duration: countdownDuration))
        _inspection = StateObject(wrappedValue: Inspection(duration: inspectionDuration))
        
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
            .onChange(of: countdown.complete) { isComplete in
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
                    } else if timerState == .inspection {
                        try? inspection.reset()
                    } else {
                        try? countdown.reset()
                    }
                case .counting:
                    try? countdown.start()
                case .inspection:
                    try? countdown.reset()
                    
                    try? inspection.start()
                case .running:
                    try? countdown.reset()
                    
                    try? inspection.reset()
                    
                    try? stopwatch.start()
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
