//
//  InstanceSettings.swift
//  Cubing Timer
//
//  Created by Cameron Delong on 8/23/21.
//

import SwiftUI

struct InstanceSettings: View {
    // MARK: Properties
    /// The `Instance` being edited.
    @ObservedObject var instance: Instance
    
    // MARK: Body
    var body: some View {
        Form {
            Section(header: Text("Primary Statistic")) {
                Picker(selection: $instance.primaryStatistic.kind, label: Text("Type")) {
                    ForEach(Statistic.Kind.allCases, id: \.self) { statistic in
                        Text(statistic.formattedName)
                            .tag(statistic)
                    }
                }
                
                if instance.primaryStatistic.modifier != nil {
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
                
                if instance.secondaryStatistic.modifier != nil {
                    NumberField(title: instance.secondaryStatistic.modifierTitle!, value: Binding($instance.secondaryStatistic.modifier)!, in: 3...Int.max)
                }
            }
        }
        .navigationTitle("\(instance.name) - Settings")
    }
}
