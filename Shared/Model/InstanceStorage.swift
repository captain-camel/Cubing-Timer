//
//  InstanceStorage.swift
//  Cubing Timer
//
//  Created by Cameron Delong on 8/7/21.
//

import CoreData

class InstanceStorage {
    // MARK: Properties
    /// A singleton instance of `InstanceStorage`.
    static let shared = InstanceStorage()

    /// The array of all `Instance`s fetched from Core Data.
    private var instances: [Instance]!
    
    // MARK: Initializers
    /// Creates an instance of `InstanceStorage` and fetches all `Instances` from Core Data.
    init() {
        try? fetchInstances()
    }
    
    // MARK: Methods
    /// Returns all of the `Instances` from Core Data.
    func fetchInstances() throws {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Instance")
        
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(
                keyPath: \Instance.order,
                ascending: true),
            NSSortDescriptor(
                keyPath:\Instance.name,
                ascending: true)
        ]
        
        do {
            let fetchedInstances = try PersistenceController.viewContext.fetch(fetchRequest) as! [Instance]
            instances = fetchedInstances
        } catch {
            throw error
        }
    }
    
    /// Creates a new `Instance` and saves it to Core Data.
    static func add(name: String, puzzle: Puzzle, notes: String? = nil, primaryStatistic: Statistic = Statistic(kind: .average, modifier: 5), secondaryStatistic: Statistic = Statistic(kind: .average, modifier: 12), inspectionDuration: Int? = 15, order: Int? = nil, id: UUID = UUID()) {
        let newInstance = Instance(context: PersistenceController.viewContext)
        
        newInstance.name = name
        newInstance.puzzleRawValue = String(puzzle)
        newInstance.notes = notes
        
        newInstance.primaryStatisticRawValue = primaryStatistic.description
        newInstance.secondaryStatisticRawValue = secondaryStatistic.description
        
        newInstance.primaryStatistic.setInstance(to: newInstance)
        newInstance.secondaryStatistic.setInstance(to: newInstance)
        
        newInstance.inspectionDuration = inspectionDuration != nil ? Int64(inspectionDuration!) : nil

        if order == nil {
            newInstance.order = (Self.shared.instances.map { $0.order }.max() ?? -1) + 1
        } else {
            newInstance.order = Int16(order!)
        }
        
        newInstance.id = id
        
        PersistenceController.save()
        
        try? Self.shared.fetchInstances()
    }
    
    /// Deletes an `Instance`.
    static func delete(_ instance: Instance) {
        PersistenceController.viewContext.delete(instance)
        
        PersistenceController.save()
        
        try? Self.shared.fetchInstances()
    }
    
    static func delete(at indices: IndexSet) {
        for index in indices {
            if Self.shared.instances.indices.contains(index) {
                PersistenceController.viewContext.delete(Self.shared.instances[index])
            }
        }
        
        PersistenceController.save()
        
        try? Self.shared.fetchInstances()
    }
}
