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
    
    /// The example code displayed.
    let exampleCode = """
    let moves = ['R', 'L']
    let scramble = \"\"
    
    for (let i = 0; i < 10; i++) {
        scramble += moves[Math.floor(Math.random() * moves.length)] // get random item from `moves`
    }
    
    return scramble
    """
    
    // MARK: Body
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("If a puzzle doesn't have a build in scramble generator, you can create your own using Javascript\n\nJust return a string containing a scramble to display.")
                CodeView(exampleCode)
                    .padding(.vertical)
                Text("Press the play button to test your code. Once you use the timer, your custom scramles will appear like normal.")
                Spacer()
            }
            .padding()
            .multilineTextAlignment(.leading)
            .navigationTitle("Custom Scramble Help")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Link("JS Documentation", destination: URL(string: "https://developer.mozilla.org/en-US/docs/Web/JavaScript")!)
                }
                
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
