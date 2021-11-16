//
//  SettingsView.swift
//  Cubing Timer
//
//  Created by Cameron Delong on 9/8/21.
//

import SwiftUI

/// A view that displays global settings.
struct SettingsView: View {
    // MARK: Body
    var body: some View {
        Form {
            Section(header: Text("Colors"), footer: Text("These are the colors of the background when timing solves.")) {
                ColorPicker("Timer Background", selection: Settings.shared.$runningColor, supportsOpacity: false)
                
                ColorPicker("Inspection Background", selection: Settings.shared.$inspectionColor, supportsOpacity: false)
            }
            
            Section(header: Text("Haptic Feedback")) {
                Toggle("Haptic Feedback", isOn: Settings.shared.$doHaptics)
            }
        }
        .navigationTitle("Settings")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Restore Defaults") {
                    withAnimation {
                        Settings.shared.restoreDefaults()
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
