//
//  AddInstanceSheet.swift
//  Cubing Timer
//
//  Created by Cameron Delong on 8/15/21.
//

import SwiftUI

struct AddInstanceSheet: View {
    // MARK: Properties
    /// The presentation mode of the sheet.
    @Environment(\.presentationMode) var presentationMode
    
    /// A callback that is called when the button to create the new `Instance` is pressed.
    let create: (_ name: String, _ puzzle: String, _ notes: String?) -> Void
    
    /// The name of the new `Instance`.
    @State var name = ""
    /// The `Puzzle` assigned to the new `Instance`.
    @State var puzzle: Puzzle = ._3x3
    /// Notes about the new `Instance`.
    @State var notes = ""
    
    // MARK: Body
    var body: some View {
        let puzzleString = Binding(
            get: {
                switch puzzle {
                case let .other(puzzle):
                    return puzzle
                default:
                    return puzzle.stringValue
                }
            },
            set: {
                puzzle = Puzzle(from: $0)
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
                            Text(puzzle.stringValue)
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
                        create(
                            name,
                            puzzleString.wrappedValue,
                            notes == ""
                                ? nil
                                : notes)

                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(name == "" || puzzleString.wrappedValue == "")
                }
            }
        }
    }
}
