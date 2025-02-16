//
//  Medication.swift
//  MediTrack
//
//  Created by Oleksandr Matrosov on 15/2/25.
//

import Foundation

struct Medication: Identifiable {
    let id: UUID
    let name: String
    let dosage: String
    let time: Date
}
