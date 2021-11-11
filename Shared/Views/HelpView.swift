//
//  HelpView.swift
//  Cubing Timer
//
//  Created by Cameron Delong on 10/3/21.
//

import SwiftUI
import MarkdownUI

/// A view displaying help on how to use the app.
struct HelpView: View {
    // MARK: Properties
    /// Markdown to display when help file fails to load.
    let errorMessage = """
                ## Uh oh!
                There was an error loading help page...
                """
    
    /// The markdown text to display
    let text: String
    
    // MARK: Initializers
    init() {
        if let path = Bundle.main.path(forResource: "HELP", ofType: "md") {
            do {
                text = try String(contentsOfFile: path)
            } catch {
                text = errorMessage
            }
        } else {
            text = errorMessage
        }
    }
    
    // MARK: Body
    var body: some View {
        ScrollView {
            Markdown(Document(text))
                .padding()
        }
        .navigationTitle("Help")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct HelpView_Previews: PreviewProvider {
    static var previews: some View {
        HelpView()
    }
}
