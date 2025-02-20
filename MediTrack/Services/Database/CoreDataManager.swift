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
        
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        print(paths[0])
    }

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveMedication(_ medication: Medication, completion: @escaping (Bool) -> Void) {
        let medicationEntity = MedicationEntity(context: context)
        medicationEntity.name = medication.name
        medicationEntity.dosage = medication.dosage
        medicationEntity.time = medication.time

        do {
            try context.save()
            print("✅ Medication saved successfully!")
            completion(true)
        } catch {
            print("❌ Failed to save medication: \(error.localizedDescription)")
            completion(false)
        }
    }
    
    func fetchMedications() -> [Medication] {
        let fetchRequest: NSFetchRequest<MedicationEntity> = MedicationEntity.fetchRequest()
        
        do {
            let medicationEntities = try context.fetch(fetchRequest)
            return medicationEntities.map { entity in
                Medication(
                    id: entity.objectID.uriRepresentation().absoluteString,
                    name: entity.name ?? "",
                    dosage: entity.dosage ?? "",
                    time: entity.time ?? Date()
                )
            }
        } catch {
            print("❌ Failed to fetch medications: \(error)")
            return []
        }
    }
    
    func deleteMedication(_ medication: Medication, completion: @escaping (Bool) -> Void) {
        guard let objectIDURL = URL(string: medication.id),
              let objectID = context.persistentStoreCoordinator?.managedObjectID(forURIRepresentation: objectIDURL)
        else {
            print("❌ Invalid object ID: \(medication.id)")
            completion(false)
            return
        }

        do {
            let objectToDelete = context.object(with: objectID)
            context.delete(objectToDelete)
            try context.save()
            print("✅ Medication deleted successfully!")
            completion(true)
        } catch {
            print("❌ Failed to delete medication: \(error.localizedDescription)")
            completion(false)
        }
    }

}

extension CoreDataManager {
    @MainActor
    static let preview: CoreDataManager = {
        return CoreDataManager(container: PersistenceController.preview.container)
    }()
}
