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
    
    /// The state of any drag gesture in progress.
    @State var gestureState: GestureState = .none
    
//    @State var timerState: TimerView.TimerState = .none
    
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
            TimerView(gestureState: $gestureState) { time in
                instance.addSolve(time: time)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .contentShape(Rectangle())
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { gesture in
                    let horizontalDistance = gesture.translation.width
                    let verticalDistance = gesture.translation.height
                    
                    let totalDistance = (pow(gesture.translation.height, 2) + pow(gesture.translation.width, 2)).squareRoot()
                    
                    if totalDistance < 15 {
                        gestureState = .stationary
                    } else if (pow(gesture.translation.height, 2) + pow(gesture.translation.width, 2)).squareRoot() > 15 && (gestureState == .none || gestureState == .stationary) {
                        print(gestureState)
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
                    }
                }
                .onEnded { gesture in
                    switch gestureState.direction {
                    case .right:
                        print("right")
                    case .left:
                        print("left")
                    case .up:
                        print("up")
                    case .down:
                        print("down")
                    default:
                        break
                    }
                    
                    gestureState = .none
                }
        )
    }
    
    // MARK: Types
    /// Possible states for a `DragGesture` to be in.
    enum GestureState: Equatable {
        // MARK: Cases
        /// No gesture in progress.
        case none
        /// Gesture started but not moved.
        case stationary
        /// Gesture moved.
        case moved(GestureDirection, CGFloat)

        /// A unique if for each `GestureState`.
        var id: Int {
            switch self {
            case .none:
                return 0
            case .stationary:
                return 1
            case .moved:
                return 2
            }
        }
        
        /// The distance that has been swiped left, right, up, or down.
        var distance: CGFloat? {
            switch self {
            case let .moved(_, distance):
                return distance
            default:
                return nil
            }
        }
        
        /// The direction that was swiped.
        var direction: GestureDirection? {
            switch self {
            case let .moved(direction, _):
                return direction
            default:
                return nil
            }
        }
    }
    
    /// Possible directions for a `DragGesture` to be in.
    enum GestureDirection {
        /// Swiped left.
        case left
        /// Swiped right.
        case right
        /// Swiped up.
        case up
        /// Swiped down.
        case down
    }
}
