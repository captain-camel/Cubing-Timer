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
    /// The color of the circle behind the timer.
    static let circleColor = Color(red: 0.27, green: 0.95, blue: 0.65)
    
    /// The `Instance` displayed by the `InstanceView`.
    @ObservedObject var instance: Instance
    
    /// The presentation mode of the view.
    @Environment(\.presentationMode) var presentationMode
    
    /// The state of any drag gesture in progress.
    @State private var gestureState: GestureState = .none
    
    /// The state of the `TimerView` in the `InstanceView`.
    @State private var timerState: TimerView.TimerState = .stopped
    
    /// All of the `Solve`s fetched from Core Data belonging to the current `Instance`.
    @FetchRequest var solves: FetchedResults<Solve>
    
    /// Whether the `Instance`'s settings are displayed.
    @State private var showingSettings = false
    
    /// The scale of the circle behind the timer that is displayed when the timer is runing.
    private var runningCircleScale: CGFloat {
        if timerState == .running {
            return 3
        } else if timerState == .ready && !instance.inspection {
            return 0.7
        } else {
            return 0.0001
        }
    }
    
    /// The scale of the circle behind the timer that is displayed during inspection.
    private var inspectionCircleScale: CGFloat {
        if (timerState == .inspection || timerState == .running) && instance.inspection {
            return 3
        } else if timerState == .ready && instance.inspection {
            return 0.7
        } else {
            return 0.0001
        }
    }
    
    // MARK: Initializers
    init(instance: Instance) {
        self.instance = instance
        
        self._solves = FetchRequest(
            entity: Solve.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \Solve.date, ascending: true)],
            predicate: NSPredicate(format: "instance == %@", instance),
            animation: .easeInOut
        )
    }
    
    // MARK: Body
    var body: some View {
        VStack {
            TimerView(timerState: $timerState, inspectionDuration: instance.inspectionDuration) { time in
                instance.addSolve(time: time)
            }
            
            HStack {
                StatisticView($instance.primaryStatistic)
                StatisticView($instance.secondaryStatistic)
            }
        }
        .navigationTitle(instance.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingSettings = true
                } label: {
                    Image(systemName: "slider.horizontal.3")
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            ZStack {
                Circle()
                    .foregroundColor(.yellow)
                    .scaleEffect(inspectionCircleScale)
                    .animation(timerState == .ready ? .spring(response: 0.5, dampingFraction: 0.5, blendDuration: 0.5) : .easeIn, value: inspectionCircleScale)
                
                Circle()
                    .foregroundColor(Self.circleColor)
                    .scaleEffect(runningCircleScale)
                    .animation(timerState == .ready ? .spring(response: 0.5, dampingFraction: 0.5, blendDuration: 0.5) : .easeIn, value: runningCircleScale)
            }
        )
        .offset(gestureState.translation)
        .animation(.easeIn, value: gestureState.translation)
        .contentShape(Rectangle())
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { gesture in
                    if gestureState != .complete {
                        switch timerState {
                        case .stopped, .counting:
                            if gesture.translation.distance > 15 && gestureState == .stationary {
                                if abs(gesture.translation.width) > abs(gesture.translation.height) {
                                    if gesture.translation.width < 0 {
                                        gestureState = .moved(.left)
                                    } else {
                                        gestureState = .moved(.right)
                                    }
                                } else {
                                    if gesture.translation.height < 0 {
                                        gestureState = .moved(.up)
                                    } else {
                                        gestureState = .moved(.down)
                                    }
                                }
                                
                                timerState = .stopped
                            } else {
                                if case .moved = gestureState {} else {
                                    timerState = .counting
                                    
                                    gestureState = .stationary
                                }
                            }
                            
                        case .inspection:
                            timerState = .running
                            
                            gestureState = .complete
                            
                        case .running:
                            timerState = .stopped
                            
                            gestureState = .complete
                            
                        default:
                            break
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
                        if timerState == .ready {
                            if instance.inspectionDuration != nil {
                                timerState = .inspection
                            } else {
                                timerState = .running
                            }
                        } else if timerState == .counting {
                            timerState = .stopped
                        }
                    }
                    
                    gestureState = .none
                }
        )
        .onChange(of: presentationMode.wrappedValue.isPresented) { isPresented in
            if !isPresented {
                timerState = .stopped
            }
        }
        
        NavigationLink(destination: InstanceSettings(instance: instance), isActive: $showingSettings){
            EmptyView()
        }
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
        case moved(GestureDirection)
        /// The gesture is complete.
        case complete
        
        /// The translation of the gesture in a single direction.
        var translation: CGSize {
            switch self {
            case let .moved(direction):
                switch direction {
                case .left:
                    return CGSize(width: -15, height: 0)
                case .right:
                    return CGSize(width: 15, height: 0)
                case .up:
                    return CGSize(width: 0, height: -15)
                case .down:
                    return CGSize(width: 0, height: 15)
                }
            default:
                return CGSize.zero
            }
        }
        
        /// The direction of the gesture.
        var direction: GestureDirection? {
            switch self {
            case let .moved(direction):
                return direction
            default:
                return nil
            }
        }
    }
    
    /// Possible directions for a `DragGesture` to be in.
    enum GestureDirection: Equatable {
        /// Left.
        case left
        /// Right.
        case right
        /// Up.
        case up
        /// Down.
        case down
    }
}
