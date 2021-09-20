//
//  JavaScriptEditor.swift
//  JavaScriptEditor
//
//  Created by Cameron Delong on 9/12/21.
//

import SwiftUI
import Introspect

/// A view for editing Javascript code.
struct JavaScriptEditor: View {
    // MARK: Properties
    /// The title of the view.
    let title: String
    
    /// The Javascript code.
    @Binding var code: String
    
    /// The result of the code.
    @State private var result: CustomStringConvertible = ""
    
    /// Whether the alert showing the result of the code is presented.
    @State private var showingResultAlert = false
    
    /// Whether the help sheet is presented.
    @State private var showingHelpSheet = false
    
    /// The presentation mode of the sheet.
    @Environment(\.presentationMode) var presentationMode
    
    // MARK: Initializers
    init(_ title: String, code: Binding<String>) {
        self.title = title
        
        self._code = code
    }
    
    // MARK: Body
    var body: some View {
        NavigationView {
            TextEditor(text: $code)
                .padding(.top)
                .font(.system(.body, design: .monospaced))
                .introspectTextView { textView in
                    textView.smartQuotesType = .no
                    textView.smartDashesType = .no
                }
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .navigationTitle(title)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            do {
                                try result = JavaScript.shared.execute(code) as? CustomStringConvertible ?? "Type Error: Unsupported type returned"
                            } catch let JavaScript.JavaScriptError.runtimeError(error) {
                                result = error
                            } catch {
                                result = "Error"
                            }
                            
                            showingResultAlert = true
                        } label: {
                            Image(systemName: "play")
                        }
                        
                        
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            ()
                        } label: {
                            Image(systemName: "questionmark.circle")
                        }
                    }
                    
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Done") {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
                .alert(isPresented: $showingResultAlert) {
                    Alert(title: Text("Result"), message: Text(result.description), dismissButton: .default(Text("OK")))
                }
                .sheet(isPresented: $showingHelpSheet) {
                    
                }
        }
    }
}

struct JavaScriptEditor_Previews: PreviewProvider {
    static var previews: some View {
        JavaScriptEditor("Editor", code: .constant("return 'hello world';"))
    }
}
