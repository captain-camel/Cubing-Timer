//
//  CodeView.swift
//  CodeView
//
//  Created by Cameron Delong on 9/20/21.
//

import SwiftUI

/// A box showing monospaced text.
struct CodeView: View {
    // MARK: Properties
    /// The `String` to display.
    let text: String
    
    // MARK: Initializers
    init(_ text: String) {
        self.text = text
    }
    
    // MARK: Body
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color(.systemGray6))
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.secondary, lineWidth: 1)
            
            HStack {
                Text(text)
                    .multilineTextAlignment(.leading)
                    .font(.system(.body, design: .monospaced))
                    .padding()
                
                Spacer()
            }
        }
        .fixedSize(horizontal: false, vertical: true)
    }
}

struct CodeView_Previews: PreviewProvider {
    static var previews: some View {
        CodeView("example\nexample2")
            .padding()
    }
}
