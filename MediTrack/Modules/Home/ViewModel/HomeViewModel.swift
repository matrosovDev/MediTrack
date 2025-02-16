//
//  HomeViewModel.swift
//  MediTrack
//
//  Created by Oleksandr Matrosov on 15/2/25.
//

import Foundation

@Observable
class HomeViewModel {
    var medications: [Medication] = []
    private let coreDataManager: CoreDataManager
    
    init(coreDataManager: CoreDataManager = CoreDataManager.shared) {
        self.coreDataManager = coreDataManager
        loadMedications()
    }
    
    func addMedication(_ medication: Medication) {
        medications.append(medication)
        coreDataManager.saveMedication(medication)
    }
    
    func removeMedication(at index: Int) {
        let medication = medications[index]
        coreDataManager.deleteMedication(medication)
        medications.remove(at: index)
    }
    
    private func loadMedications() {
        medications = coreDataManager.fetchMedications()
    }
}
