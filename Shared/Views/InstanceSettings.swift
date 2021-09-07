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
    
    /// Whether the code editor sheet is displayed.
    @State private var showingCodeEditorSheet = false
    
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
                    ForEach(Statistic.allCases, id: \.self) { statistic in
                        Text(statistic.kindName)
                            .tag(statistic)
                    }
                }
                
                switch instance.primaryStatistic {
                case .average:
                    NumberField(title: "Average of", value: Binding(
                        get: {
                            switch instance.primaryStatistic {
                            case let .mean(solves):
                                return solves
                            default:
                                return 5
                            }
                        },
                        set: {
                            instance.primaryStatistic = .mean($0)
                            
                        }
                    ), in: 3...Int.max)
                case .mean:
                    NumberField(title: "Mean of", value: Binding(
                        get: {
                            switch instance.primaryStatistic {
                            case let .mean(solves):
                                return solves
                            default:
                                return 5
                            }
                        },
                        set: {
                            instance.primaryStatistic = .mean($0)
                            
                        }
                    ), in: 1...Int.max)
                default:
                    EmptyView()
                }
            }
            
            Section(header: Text("Secondary Statistic")) {
                Picker(selection: $instance.secondaryStatistic.kind, label: Text("Type")) {
                    ForEach(Statistic.allCases, id: \.self) { statistic in
                        Text(statistic.kindName)
                            .tag(statistic)
                    }
                }
                
                switch instance.secondaryStatistic {
                case .average:
                    NumberField(title: "Average of", value: Binding(
                        get: {
                            switch instance.secondaryStatistic {
                            case let .average(solves):
                                return solves
                            default:
                                return 5
                            }
                        },
                        set: {
                            instance.secondaryStatistic = .average($0)
                            
                        }
                    ), in: 3...Int.max)
                case .mean:
                    NumberField(title: "Mean of", value: Binding(
                        get: {
                            switch instance.secondaryStatistic {
                            case let .mean(solves):
                                return solves
                            default:
                                return 5
                            }
                        },
                        set: {
                            instance.secondaryStatistic = .mean($0)
                            
                        }
                    ), in: 1...Int.max)
                default:
                    EmptyView()
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
            
            Section(header: Text("Scramble"), footer: Text(instance.showScramble && Algorithm.scramble(puzzle: instance.puzzle) == nil ? "hellotest" : "")) {
                Toggle("Show Scramble", isOn: $instance.showScramble)
                
                if instance.showScramble && Algorithm.scramble(puzzle: instance.puzzle) == nil {
                    Button(instance.customScrambleAlgorithm == "" ? "Create Custom Scrambler" : "Edit Custom Scrambler") {
                        showingCodeEditorSheet = true
                    }
                }
            }
        }
        .navigationTitle("\(instance.name) - Settings")
        .onChange(of: instance.doInspection) { doInspection in
            withAnimation {
                self.doInspection = doInspection
            }
        }
        .sheet(isPresented: $showingCodeEditorSheet) {
            NavigationView {
                TextEditor(text: $instance.customScrambleAlgorithm)
                    .padding(.top)
                    .font(.system(.body, design: .monospaced))
                    .navigationTitle("\(instance.name)")
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}
