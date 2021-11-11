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
    
    /// A manager to handle HUD notifications.
    @EnvironmentObject var hudManager: HUDManager
    
    /// A manager to handle haptic feedback.
    @EnvironmentObject var hapticManager: HapticManager
    
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
    
    /// The scramble displayed.
    @State private var scramble = ""
    
    /// The size of the `TimerView`.
    @State private var timerSize = CGSize(width: 0, height: 0)
    
    /// Whether the details sheet is showing.
    @State private var showingDetailSheet = false
    
    /// The color of the background when the timer is running.
    @AppStorage("runningColor") var runningColor = Color(red: 0.27, green: 0.95, blue: 0.65)
    /// The color of the background during inspection.
    @AppStorage("inspectionColor") var inspectionColor = Color.yellow
    
    /// The scale of the circle behind the timer that is displayed when the timer is running.
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
            return 4
        } else if timerState == .ready && instance.doInspection {
            return 0.7
        } else {
            return 0.0001
        }
    }
    
    // MARK: Initializers
    init(instance: Instance) {
        self.instance = instance
        
        _solves = FetchRequest(
            entity: Solve.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \Solve.date, ascending: true)],
            predicate: NSPredicate(format: "instance == %@", instance),
            animation: .easeInOut
        )
    }
    
    // MARK: Body
    var body: some View {
        ZStack {
            VStack {
                if instance.showScramble {
                    Text(scramble)
                        .bold()
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding()
                        .onAppear {
                            scramble = instance.getScramble()
                        }
                }
                
                Spacer()
                
                Button {
                    hapticManager.tap()
                    
                    showingDetailSheet = true
                } label: {
                    Image(systemName: "chevron.compact.up")
                        .font(.system(size: 60))
                        .foregroundColor(.secondary)
                        .padding()
                        .offset(y: min(gestureState.rawTranslation.height, 0))
                        .animation(.default)
                }
                .highPriorityGesture(
                    DragGesture(minimumDistance: 20)
                        .onChanged { gesture in
                            gestureChanged(gesture)
                        }
                        .onEnded { gesture in
                            gestureEnded(gesture)
                        }
                )
            }
            
            HStack {
                VStack {
                    TimerView(timerState: $timerState, solve: solves.last, inspectionDuration: $instance.wrappedInspectionDuration) { time in
                        if time < instance.unwrappedSolves.map({ ($0 as? Solve)?.adjustedTime ?? 0 }).min() ?? 0 {
                            hudManager.showHUD(text: "New personal best!", systemImage: "sparkles", imageColor: .yellow)
                            
                            hapticManager.fireworks()
                        }
                        
                        instance.addSolve(time: time, scramble: scramble)
                    }
                    .readSize(size: $timerSize)
                    .offset(gestureState.translation)
                    .animation(.default, value: gestureState.translation)
                    
                    if horizontalSizeClass == .compact {
                        HStack {
                            TimerActions(solve: solves.last)
                        }
                        .frame(width: timerSize.width)
                        .opacity(timerState == .stopped ? 1 : 0)
                    }
                    
                    HStack {
                        StatisticView(instance.primaryStatistic, instance: instance)
                        StatisticView(instance.secondaryStatistic, instance: instance)
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
                ZStack {// TODO: Use frame instad of scale, and calculate the radius with pythagoran thoemre. Also use CGFloat.leastnonzero for small
                    Circle()
                        .foregroundColor(inspectionColor)
                        .scaleEffect(inspectionCircleScale)
                    
                    Circle()
                        .foregroundColor(runningColor)
                        .scaleEffect(runningCircleScale)
                }
                    .offset(y: -10)
            )
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { gesture in
                        gestureChanged(gesture)
                    }
                    .onEnded { gesture in
                        gestureEnded(gesture)
                    }
            )
            .padding(.bottom, 50)
            .onChange(of: presentationMode.wrappedValue.isPresented) { isPresented in
                if !isPresented {
                    withAnimation {
                        timerState = .stopped
                    }
                    
                    gestureState = .none
                }
            }
            .onChange(of: scenePhase) { _ in
                timerState = .stopped
                gestureState = .none
            }
        }
        .sheet(isPresented: $showingDetailSheet) {
            InstanceDetailSheet(instance: instance)
        }
        
        NavigationLink(destination: InstanceSettings(instance: instance), isActive: $showingSettings) {
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
        case stationary(CGSize)
        /// Gesture moved.
        case moved(CGSize)
        /// The gesture is complete.
        case complete
        
        /// The translation of the gesture in a single direction.
        var translation: CGSize {
            switch self {
            case let .stationary(translation):
                return translation
                
            case let .moved(translation):
                switch direction {
                case .left:
                    return CGSize(width: translation.width, height: 0)
                case .right:
                    return CGSize(width: translation.width, height: 0)
                case .up:
                    return CGSize.zero
                case .down:
                    return CGSize(width: 0, height: translation.height)
                default:
                    return CGSize.zero
                }
                
            default:
                return CGSize.zero
            }
        }
        
        /// The raw translation of the gesture.
        var rawTranslation: CGSize {
            switch self {
            case let .stationary(translation):
                return translation
                
            case let .moved(translation):
                return translation
                
            default:
                return CGSize.zero
            }
        }
        
        /// The direction of the gesture.
        var direction: GestureDirection? {
            switch self {
            case let .moved(translation):
                if abs(translation.width) > abs(translation.height) {
                    if translation.width < 0 {
                        return .left
                    } else {
                        return .right
                    }
                } else {
                    if translation.height < 0 {
                        return .up
                    } else {
                        return .down
                    }
                }
                
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
    /// Logic to handle when a gesture starts or changes.
    func gestureChanged(_ gesture: DragGesture.Value) {
        if gestureState != .complete {
            switch timerState {
            case .stopped, .counting:
                if gesture.translation.distance < 100 {
                    if case .stationary = gestureState, gesture.translation.distance > 25 {
                        hapticManager.tap()
                        
                        gestureState = .moved(gesture.translation)
                        
                        withAnimation {
                            timerState = .stopped
                        }
                    } else {
                        if case .moved = gestureState {} else {
                            withAnimation(.default.delay(0.3)) {
                                timerState = .counting
                            }
                            
                            gestureState = .stationary(gesture.translation)
                        }
                    }
                }
                
            case .inspection:
                withAnimation {
                    timerState = .running
                }
                
                gestureState = .complete
                
                hapticManager.tap()
                
            case .running:
                withAnimation {
                    timerState = .stopped
                    
                    scramble = instance.getScramble()
                }
                
                gestureState = .complete
                
                hapticManager.tap()
                
            default:
                break
            }
        }
    }
    
    /// Logic to handle the end of a gesture.
    func gestureEnded(_ gesture: DragGesture.Value) {
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
                hapticManager.error()
            }
            
        case .left:
            if let lastSolve = instance.solveArray.last {
                SolveStorage.delete(lastSolve)
                
                hudManager.showHUD(text: "Solve deleted.", systemImage: "trash", imageColor: .red)
            } else {
                hapticManager.error()
            }
            
        case .up:
            showingDetailSheet = true
            
        case .down:
            withAnimation {
                if instance.solveArray.last?.penalty == .dnf {
                    instance.solveArray.last?.penalty = .none
                } else {
                    instance.solveArray.last?.penalty = .dnf
                }
            }
            
            if instance.solveArray.isEmpty {
                hapticManager.error()
            }
            
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
                
                hapticManager.tap()
            } else if timerState == .counting {
                withAnimation {
                    timerState = .stopped
                }
            }
        }
        
        gestureState = .none
    }
}
