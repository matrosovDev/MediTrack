//
//  HomeViewModel.swift
//  MediTrack
//
//  Created by Oleksandr Matrosov on 15/2/25.
//

import Foundation
import UserNotifications

@Observable
class HomeViewModel {
    var medications: [Medication] = []
    private let coreDataManager: CoreDataManager
    
    init(coreDataManager: CoreDataManager = CoreDataManager.shared) {
        self.coreDataManager = coreDataManager
        loadMedications()
    }
    
    func addMedication(_ medication: Medication) {
        coreDataManager.saveMedication(medication) { success in
            if success {
                DispatchQueue.main.async {
                    self.medications.append(medication)
                    self.scheduleMedicationNotification(for: medication)
                }
            } else {
                print("❌ Error: Medication was not saved, notification not scheduled")
            }
        }
    }
    
    func removeMedication(at index: Int) {
        let medication = medications[index]
        coreDataManager.deleteMedication(medication) { success in
            if success {
                DispatchQueue.main.async {
                    self.medications.remove(at: index)
                    self.removeMedicationNotification(for: medication)
                }
            } else {
                print("❌ Error: Medication was not deleted, notification not removed")
            }
        }
    }
    
    private func loadMedications() {
        medications = coreDataManager.fetchMedications()
    }
    
    private func scheduleMedicationNotification(for medication: Medication) {
        let content = UNMutableNotificationContent()
        content.title = "Time to take your medication 💊"
        content.body = "Take \(medication.name) - \(medication.dosage)"
        content.sound = .default
        
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: medication.time)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        let request = UNNotificationRequest(identifier: medication.id, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("🔔 Notification scheduled for \(medication.time)")
            }
        }
    }
    
    private func removeMedicationNotification(for medication: Medication) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [medication.id])
        print("🚫 Notification removed for \(medication.name)")
    }
}
