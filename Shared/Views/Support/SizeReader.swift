//
//  SizeReader.swift
//  Cubing Timer
//
//  Created by Cameron Delong on 8/27/21.
//

import SwiftUI

struct SizeReader: View {
    @Binding var size: CGSize
    
    var body: some View {
        GeometryReader { geometry in
            Color.clear
                .onAppear {
                    size = geometry.size
                }
                .onChange(of: geometry.size) { _ in
                    size = geometry.size
                }
        }
    }
}
