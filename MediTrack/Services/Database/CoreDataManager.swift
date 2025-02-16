//
//  CoreDataManager.swift
//  MediTrack
//
//  Created by Oleksandr Matrosov on 16/2/25.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer
    
    init(container: NSPersistentContainer = PersistenceController.shared.container) {
        self.persistentContainer = container
    }

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveMedication(_ medication: Medication) {
        let medicationEntity = MedicationEntity(context: context)
        medicationEntity.name = medication.name
        medicationEntity.dosage = medication.dosage
        medicationEntity.time = medication.time
        
        saveContext()
    }
    
    func fetchMedications() -> [Medication] {
        let fetchRequest: NSFetchRequest<MedicationEntity> = MedicationEntity.fetchRequest()
        
        do {
            let medicationEntities = try context.fetch(fetchRequest)
            return medicationEntities.map {
                Medication(id: $0.id ?? UUID(), name: $0.name ?? "", dosage: $0.dosage ?? "", time: $0.time ?? Date())
            }
        } catch {
            print("Failed to fetch medications: \(error)")
            return []
        }
    }
    
    func deleteMedication(_ medication: Medication) {
        let fetchRequest: NSFetchRequest<MedicationEntity> = MedicationEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", medication.id as CVarArg)
        
        do {
            let results = try context.fetch(fetchRequest)
            if let objectToDelete = results.first {
                context.delete(objectToDelete)
                saveContext()
            }
        } catch {
            print("Failed to delete medication: \(error)")
        }
    }
    
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }
}

extension CoreDataManager {
    @MainActor
    static let preview: CoreDataManager = {
        return CoreDataManager(container: PersistenceController.preview.container)
    }()
}


