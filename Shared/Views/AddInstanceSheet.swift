//
//  AddInstanceSheet.swift
//  Cubing Timer
//
//  Created by Cameron Delong on 8/15/21.
//

import SwiftUI

/// A sheet to create a new `Instance`.
struct AddInstanceSheet: View {
    // MARK: Properties
    /// The name of the new `Instance`.
    @State private var name = ""
    /// The `Puzzle` assigned to the new `Instance`.
    @State private var puzzle: Puzzle = .cube(3)
    /// Whether the new `Instance` should have inspection.
    @State private var doInspection = true
    /// The duration of the inspection of the new `Instance`.
    @State private var inspectionDuration = 15
    
    /// A callback that is called when the button to create the new `Instance` is pressed.
    let createAction: (_ name: String, _ puzzle: Puzzle, _ inspectionDuration: Int?) -> Void
    
    /// The presentation mode of the sheet.
    @Environment(\.presentationMode) var presentationMode

    // MARK: Body
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Name")) {
                    TextField(String(puzzle), text: $name)
                }
                
                Section(header: Text("Puzzle")) {
                    Picker(selection: $puzzle.kind, label: Text("Puzzle")) {
                        ForEach(Puzzle.allCases, id: \.self) { puzzle in
                            Text(String(puzzle.displayName))
                                .tag(puzzle)
                        }
                    }
                    
                    if case .other = puzzle {
                        TextField("Puzzle", text: $puzzle.other)
                    }
                }

                Section(header: Text("Inspection")) {
                    Toggle("Inspection", isOn: $doInspection.animation())
                    
                    if doInspection {
                        NumberField(title: "Duration", value: $inspectionDuration, in: 1...Int.max)
                    }
                }
            }
            .navigationBarTitle("New Instance", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") {
                        createAction(
                            name,
                            puzzle,
                            doInspection ? inspectionDuration : nil
                        )
                        
                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(name == "" || puzzle == "")
                }
            }
        }
    }
}
