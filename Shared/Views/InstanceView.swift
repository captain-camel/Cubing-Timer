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
    
    /// The color of the circle behind the timer.
    static let circleColor = Color(red: 0.27, green: 0.95, blue: 0.65)
    
    /// The presentation mode of the view.
    @Environment(\.presentationMode) var presentationMode
    
    /// The horizontal size of the view.
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    // The current phase of the scene.
    @Environment(\.scenePhase) private var scenePhase
    
    /// The state of any drag gesture in progress.
    @State private var gestureState: GestureState = .none
    
    /// The state of the `TimerView` in the `InstanceView`.
    @State private var timerState: TimerView.TimerState = .stopped
    
    /// All of the `Solve`s fetched from Core Data belonging to the current `Instance`.
    @FetchRequest var solves: FetchedResults<Solve>
    
    /// Whether the `Instance`'s settings are displayed.
    @State private var showingSettings = false
    
    /// The size of the `TimerView`.
    @State private var timerSize = CGSize(width: 0, height: 0)
    
    /// Whether a `HUD` is currently displayed.
    @State private var showingHUD = false
    
    /// The title of the `HUD`.
    @State private var HUDTitle = ""
    
    /// The system name of the icon displayed on the `HUD`.
    @State private var HUDIconSystemName = ""
    
    /// The color of the `HUD`.
    @State private var HUDIconColor: Color = .black
    
    /// The scale of the circle behind the timer that is displayed when the timer is runing.
    private var runningCircleScale: CGFloat {
        if timerState == .running {
            return 3
        } else if timerState == .ready && !instance.doInspection {
            return 0.7
        } else {
            return 0.0001
        }
    }
    
    /// The scale of the circle behind the timer that is displayed during inspection.
    private var inspectionCircleScale: CGFloat {
        if (timerState == .inspection || timerState == .running) && instance.doInspection {
            return 3
        } else if timerState == .ready && instance.doInspection {
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
        HStack {
            VStack {
                TimerView(timerState: $timerState, solve: solves.last, inspectionDuration: $instance.wrappedInspectionDuration) { time in
                    if time < instance.unwrappedSolves.map({ ($0 as? Solve)?.adjustedTime ?? 0 }).min() ?? 0 {
                        showHUD(title: "New personal best!", systemName: "sparkles", iconColor: .yellow)
                        
                        Haptics.shared.fireworks()
                    }
                    
                    instance.addSolve(time: time)
                }
                .readSize(size: $timerSize)
                
                if horizontalSizeClass == .compact {
                    HStack {
                        TimerActions(solve: solves.last)
                    }
                    .frame(width: timerSize.width)
                    .opacity(timerState == .stopped ? 1 : 0)
                }
                
                HStack {
                    StatisticView($instance.primaryStatistic, instance: instance)
                    StatisticView($instance.secondaryStatistic, instance: instance)
                }
                .padding(.horizontal)
                .opacity(timerState == .stopped ? 1 : 0)
            }
            
            if horizontalSizeClass == .regular && timerState == .stopped {
                VStack {
                    TimerActions(solve: solves.last)
                        .frame(width: 100)
                        .transition(.opacity)
                }
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
                
                Circle()
                    .foregroundColor(Self.circleColor)
                    .scaleEffect(runningCircleScale)
            }
        )
        .contentShape(Rectangle())
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { gesture in
                    if gestureState != .complete {
                        switch timerState {
                        case .stopped, .counting:
                            if gesture.translation.distance > 50 && gestureState == .stationary {
                                let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
                                impactHeavy.impactOccurred()
                                
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
                                
                                withAnimation {
                                    timerState = .stopped
                                }
                            } else {
                                if case .moved = gestureState {} else {
                                    withAnimation(.default.delay(0.3)) {
                                        timerState = .counting
                                    }
                                    
                                    gestureState = .stationary
                                }
                            }
                            
                        case .inspection:
                            withAnimation {
                                timerState = .running
                            }
                            
                            gestureState = .complete
                            
                            Haptics.shared.tap()
                            
                        case .running:
                            withAnimation {
                                timerState = .stopped
                            }
                            
                            gestureState = .complete
                            
                            Haptics.shared.tap()
                            
                        default:
                            break
                        }
                    }
                }
                .onEnded { gesture in
                    switch gestureState.direction {
                    case .right:
                        withAnimation {
                            if instance.solveArray.last?.penalty.length != nil {
                                instance.solveArray.last?.penalty = .none
                            } else {
                                instance.solveArray.last?.penalty = .some(2)
                            }
                        }
                        
                        if instance.solveArray.isEmpty {
                            Haptics.shared.error()
                        }
                        
                    case .left:
                        if !instance.solveArray.isEmpty {
                            SolveStorage.delete(instance.solveArray.last!)
                            
                            showHUD(title: "Solve Deleted", systemName: "trash", iconColor: .red)
                        } else {
                            Haptics.shared.error()
                        }
                        
                    case .up:
                        print("up")
                        
                    case .down:
                        print("down")
                        
                    default:
                        if timerState == .ready {
                            if instance.doInspection {
                                withAnimation {
                                    timerState = .inspection
                                }
                            } else {
                                withAnimation {
                                    timerState = .running
                                }
                            }
                            
                            Haptics.shared.tap()
                        } else if timerState == .counting {
                            withAnimation {
                                timerState = .stopped
                            }
                        }
                    }
                    
                    gestureState = .none
                }
        )
        .onChange(of: presentationMode.wrappedValue.isPresented) { isPresented in
            if !isPresented {
                withAnimation {
                    timerState = .stopped
                }
            }
        }
        .onChange(of: scenePhase) { _ in
            timerState = .stopped
            gestureState = .none
        }
        .hud(isPresented: $showingHUD, timeout: 3) {
            Label {
                Text(HUDTitle)
                    .bold()
            } icon: {
                Image(systemName: HUDIconSystemName)
                    .foregroundColor(HUDIconColor)
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
    
    // MARK: Methods
    /// Shows a `HUD` with a title and icon.
    func showHUD(title: String, systemName: String, iconColor: Color) {
        HUDTitle = title
        HUDIconSystemName = systemName
        HUDIconColor = iconColor
        
        withAnimation {
            showingHUD = true
        }
    }
}
