//
//  InstanceView.swift
//  Cubing Timer
//
//  Created by Cameron Delong on 8/7/21.
//

import SwiftUI

/// A view opened by a `NavigationView` showing details about an `Instance` and a timer to add solves to it.
struct InstanceView: View {
    // MARK: Properties
    /// The `Instance` displayed by the `InstanceView`.
    @ObservedObject var instance: Instance
    
    /// A stopwatch to time solves.
    @ObservedObject var stopwatch = Stopwatch()
    /// A countdown to start timing solves.
    @ObservedObject var countdown = Countdown(duration: 0.5)
    /// A timer for inspection.
    @ObservedObject var inspection = Inspection(duration: 15)
    
    /// The state of any drag gesture in progress.
    @State var gestureState: GestureState = .none
    
//    /// All of the `Solve`s fetched from Core Data belonging to the current `Instance`.
//    @FetchRequest var solves: FetchedResults<Solve>
//
//    init(instance: Instance) {
//        self.instance = instance
//
//        self._solves = FetchRequest(
//            entity: Solve.entity(),
//            sortDescriptors: [NSSortDescriptor(keyPath: \Solve.date, ascending: true)],
//            predicate: NSPredicate(format: "instance == %@", instance),
//            animation: .easeInOut
//        )
//    }
    
    // MARK: Body
    var body: some View {
        VStack {
            Text(Solve.formatTime(stopwatch.secondsElapsed))
            Text(countdown.isRunning.description)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .contentShape(Rectangle())
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { gesture in
                    let horizontalDistance = gesture.translation.width
                    let verticalDistance = gesture.translation.height
                    
                    switch gestureState {
                    case .none:
                        if stopwatch.isRunning {
                            gestureState = .complete
                            
                            try? stopwatch.stop()
                            
                            // TODO: Add solve here
                        } else {
                            gestureState = .stationary
                            
                            try? countdown.start()
                        }
                        
                    case .stationary:
                        if !countdown.complete && (pow(gesture.translation.height, 2) + pow(gesture.translation.width, 2)).squareRoot() > 15 {
                            if abs(horizontalDistance) > abs(verticalDistance) {
                                if horizontalDistance < 0 {
                                    gestureState = .moved(.left, horizontalDistance)
                                } else {
                                    gestureState = .moved(.right, horizontalDistance)
                                }
                            } else {
                                if verticalDistance < 0 {
                                    gestureState = .moved(.up, verticalDistance)
                                } else {
                                    gestureState = .moved(.down, verticalDistance)
                                }
                            }
                            
                            try? countdown.reset()
                        }
                        
                    case let .moved(direction, _):
                        switch direction {
                        case .left, .right:
                            gestureState = .moved(direction, horizontalDistance)
                        case .up, .down:
                            gestureState = .moved(direction, verticalDistance)
                        }
                        
                    default: break
                    }
                }
                .onEnded { gesture in
                    switch gestureState {
                    case .stationary:
                        if countdown.complete {
                            try? stopwatch.start()
                        }
                        
                        try? countdown.reset()
                        
                    case let .moved(direction, distance):
                        switch direction {
                        case .left:
                            print("left", distance)
                        case .right:
                            print("right", distance)
                        case .up:
                            print("up", distance)
                        case .down:
                            print("down", distance)
                        }
                        
                    default: break
                    }
                    
                    gestureState = .none
                }
        )
    }
    
    enum GestureState {
        case none
        case stationary
        case moved(GestureDirection, CGFloat)
        case complete
    }
    
    enum GestureDirection {
        case left
        case right
        case up
        case down
    }
}
