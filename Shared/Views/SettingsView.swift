//
//  SettingsView.swift
//  Cubing Timer
//
//  Created by Cameron Delong on 9/8/21.
//

import SwiftUI

/// A view that displays global settings.
struct SettingsView: View {
    // MARK: Properties
    /// An object containing all of the global settings.
    @EnvironmentObject var settings: Settings
    
    // MARK: Body
    var body: some View {
        Form {
            Section(header: Text("Colors"), footer: Text("These are the colors of the background when timing solves.")) {
                ColorPicker("Timer Background", selection: $settings.runningColor, supportsOpacity: false)
                
                ColorPicker("Inspection Background", selection: $settings.inspectionColor, supportsOpacity: false)
            }
            
            Section(header: Text("Haptic Feedback")) {
                Toggle("Haptic Feedback", isOn: $settings.doHaptics)
            }
        }
        .navigationTitle("Settings")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Restore Defaults") {
                    withAnimation {
                        settings.restoreDefaults()
                    }
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
