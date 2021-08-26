//
//  StepperField.swift
//  Cubing Timer
//
//  Created by Cameron Delong on 7/31/21.
//

import SwiftUI

///A `TextField` with a `Stepper` to the left to allow `Int` inputs.
struct NumberField: View {
    // MARK: Properties
    /// The title of the `NumberField`.
    var title: String
    
    /// The value of the `NumberField`.
    @Binding var value: Int
    
    /// The range of values that the `NumberField` can be at.
    var range: ClosedRange<Int>
    
    /// The `String` entered into the `TextField`.
    @State var string: String
    
    // MARK: Initializers
    init(title: String = "", value: Binding<Int>, in range: ClosedRange<Int>) {
        self.title = title
        
        self._value = value
        self.string = String(value.wrappedValue)
        
        self.range = range
    }
    
    // MARK: Body
    var body: some View {
        HStack {
            Text("\(title)")
            
            TextField("", text: $string)
                .frame(minWidth: 15, maxWidth: .infinity)
                .keyboardType(.numberPad)
                .padding(5)
                .background(
                    Color(.systemGray6)
                        .cornerRadius(8)
                )
                .onChange(of: string) { _ in
                    if let int = Int(string) {
                        value = int
                    } else if string != "" {
                        string = String(value)
                    }
                }
            
            Stepper("", value: $value, in: range)
                .labelsHidden()
                .onChange(of: value) { _ in
                    string = String(value)
                }
        }
        
    }
}

struct TextFieldStepper_Previews: PreviewProvider {
    static var previews: some View {
        Form {
            NumberField(title: "Average of:", value: .constant(5), in: 3...Int.max)
        }
    }
}

