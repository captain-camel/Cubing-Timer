//
//  AddInstanceSheet.swift
//  Cubing Timer
//
//  Created by Cameron Delong on 8/15/21.
//

import SwiftUI

struct AddInstanceSheet: View {
    // MARK: Properties
    /// The name of the new `Instance`.
    @State var name = ""
    /// The `Puzzle` assigned to the new `Instance`.
    @State var puzzle: Puzzle = .cube(3)
    /// Notes about the new `Instance`.
    @State var notes = ""
    /// Whether the new instance should have inspection.
    @State var inspection = true
    
    /// A callback that is called when the button to create the new `Instance` is pressed.
    let createAction: (_ name: String, _ puzzle: Puzzle, _ notes: String?, _ inspection: Bool) -> Void
    
    /// The presentation mode of the sheet.
    @Environment(\.presentationMode) var presentationMode
    
    // MARK: Body
    var body: some View {
        let puzzleString = Binding(
            get: {
                return String(puzzle)
            },
            set: {
                puzzle = Puzzle($0)
            }
        )
        
        return NavigationView {
            Form {
                Section(header: Text("Name")) {
                    TextField("Name", text: $name)
                }
                
                Section(header: Text("Puzzle")) {
                    Picker(selection: $puzzle, label: Text("Puzzle")) {
                        ForEach(Puzzle.allCases, id: \.self) { puzzle in
                            Text(puzzle.displayName)
                                .tag(puzzle)
                        }
                    }
                    
                    if case .other(_) = puzzle {
                        TextField("Puzzle", text: puzzleString)
                    }
                }
                
                Section(header: Text("Notes")) {
                    TextEditor(text: $notes)
                }
                
                Section(header: Text("Inspection")) {
                    Toggle("Inspection", isOn: $inspection)
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
                            notes == ""
                                ? nil
                                : notes,
                            inspection
                        )
                        
                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(name == "" || puzzleString.wrappedValue == "")
                }
            }
        }
    }
}
