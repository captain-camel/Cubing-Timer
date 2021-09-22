//
//  JavaScriptEditorHelp.swift
//  JavaScriptEditorHelp
//
//  Created by Cameron Delong on 9/22/21.
//

import SwiftUI

/// A help page for the `JavaScriptEditor`.
struct JavaScriptEditorHelp: View {
    // MARK: Properties
    /// The presentation mode of the sheet.
    @Environment(\.presentationMode) var presentationMode
    
    // MARK: Body
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("If a puzzle doesn't have a build in scramble generator, you can create your own using Javascript")
                Text("Just return a string containing a scramble to display. Press the play button to test your code.")
                Text("Example")
                    .font(.headline)
                CodeView("testesttt\n\ntestest\ntest")
                    .padding()
                
                Spacer()
            }
            .padding()
            .multilineTextAlignment(.leading)
            .navigationTitle("Custom Scramble Help")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

struct JavaScriptEditorHelp_Previews: PreviewProvider {
    static var previews: some View {
        JavaScriptEditorHelp()
    }
}
