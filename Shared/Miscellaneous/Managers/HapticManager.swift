//
//  HapticManager.swift
//  Haptics
//
//  Created by Cameron Delong on 9/3/21.
//

import CoreHaptics
import AudioToolbox.AudioServices
import UIKit

/// A `struct` containing different haptic feedback patterns.
class HapticManager: ObservableObject {
    // MARK: Properties
    /// The haptic engine to perform haptic feedback.
    var engine: CHHapticEngine?
    
    // MARK: Initializers
    /// Sets up the engine.
    init() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        engine = try? CHHapticEngine()
        try? engine?.start()
    }
    
    // MARK: Methods
    /// A soft pop.
    func pop() {
        if Settings.shared.doHaptics {
            AudioServicesPlaySystemSound(SystemSoundID(1520))
        }
    }
    
    /// A light tap.
    func tap() {
        if Settings.shared.doHaptics {
            let impact = UIImpactFeedbackGenerator(style: .medium)
            impact.impactOccurred()
        }
    }
    
    /// A buzz that fades out with small sharp pops.
    func fireworks() {
        if Settings.shared.doHaptics {
            var events = [CHHapticEvent]()
            var curves = [CHHapticParameterCurve]()
            
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0)
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
            
            let start = CHHapticParameterCurve.ControlPoint(relativeTime: 0, value: 1)
            let end = CHHapticParameterCurve.ControlPoint(relativeTime: 1.5, value: 0)
            
            let parameter = CHHapticParameterCurve(parameterID: .hapticIntensityControl, controlPoints: [start, end], relativeTime: 0)
            let event = CHHapticEvent(eventType: .hapticContinuous, parameters: [sharpness, intensity], relativeTime: 0, duration: 1.5)
            events.append(event)
            curves.append(parameter)
            
            for _ in 1...16 {
                let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
                let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
                let event = CHHapticEvent(eventType: .hapticTransient, parameters: [sharpness, intensity], relativeTime: TimeInterval.random(in: 0.1...1))
                events.append(event)
            }
            
            do {
                let pattern = try CHHapticPattern(events: events, parameterCurves: curves)
                
                let player = try engine?.makePlayer(with: pattern)
                try player?.start(atTime: 0)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    /// Three sharp taps.
    func error() {
        if Settings.shared.doHaptics {
            UINotificationFeedbackGenerator().notificationOccurred(.error)
        }
    }
}
