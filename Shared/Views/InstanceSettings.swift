//
//  InstanceSettings.swift
//  Cubing Timer
//
//  Created by Cameron Delong on 8/23/21.
//

import SwiftUI

/// A view to edit the properties of an `Instance`.
struct InstanceSettings: View {
    // MARK: Properties
    /// The `Instance` being edited.
    @ObservedObject var instance: Instance
    
    /// The `Instance`'s `doInspection` property.
    @State private var doInspection: Bool
    
    // MARK: Initializers
    init(instance: Instance) {
        self.instance = instance
        
        doInspection = instance.doInspection
    }

    // MARK: Body
    var body: some View {
        Form {
            Section(header: Text("Name")) {
                TextField(String(instance.puzzle), text: $instance.name)
            }
            
            Section(header: Text("Puzzle")) {
                Picker(selection: $instance.puzzle.kind, label: Text("Puzzle")) {
                    ForEach(Puzzle.allCases, id: \.self) { puzzle in
                        Text(puzzle.displayName)
                            .tag(puzzle)
                    }
                }
                
                if case .other = instance.puzzle {
                    TextField("Puzzle", text: $instance.puzzle.other)
                }
            }
            
            Section(header: Text("Primary Statistic")) {
                Picker(selection: $instance.primaryStatistic.kind, label: Text("Type")) {
                    ForEach(Statistic.Kind.allCases, id: \.self) { statistic in
                        Text(statistic.formattedName)
                            .tag(statistic)
                    }
                }
                
                if instance.primaryStatistic.modifierTitle != nil && instance.primaryStatistic.modifier != nil {
                    NumberField(title: instance.primaryStatistic.modifierTitle!, value: Binding($instance.primaryStatistic.modifier)!, in: 3...Int.max)
                }
            }
            
            Section(header: Text("Secondary Statistic")) {
                Picker(selection: $instance.secondaryStatistic.kind, label: Text("Type")) {
                    ForEach(Statistic.Kind.allCases, id: \.self) { statistic in
                        Text(statistic.formattedName)
                            .tag(statistic)
                    }
                }
                
                if instance.secondaryStatistic.modifierTitle != nil && instance.secondaryStatistic.modifier != nil {
                    NumberField(title: instance.secondaryStatistic.modifierTitle!, value: Binding($instance.secondaryStatistic.modifier)!, in: 3...Int.max)
                }
            }
            
            Section(header: Text("Inspection")) {
                Toggle("Inspection", isOn: $instance.doInspection)
                
                if doInspection {
                    NumberField(title: "Duration", value: Binding(
                        get: { Int(instance.inspectionDuration) },
                        set: { instance.inspectionDuration = Int64($0) }
                    ), in: 1...Int.max)
                }
            }
        }
        .navigationTitle("\(instance.name) - Settings")
        .onChange(of: instance.doInspection) { doInspection in
            withAnimation {
                self.doInspection = doInspection
            }
        }
    }
}
