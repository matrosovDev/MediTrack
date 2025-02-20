//
//  AddMedicationView.swift
//  MediTrack
//
//  Created by Oleksandr Matrosov on 16/2/25.
//

import SwiftUI

struct AddMedicationView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var name: String = ""
    @State private var dosage: String = ""
    @State private var time: Date = Date()
    
    let viewModel: HomeViewModel
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Medication Details")) {
                    TextField("Medication Name", text: $name)
                    TextField("Dosage", text: $dosage)
                    DatePicker("Time", selection: $time, displayedComponents: .hourAndMinute)
                }
                
                Button(action: addMedication) {
                    Text("Save Medication")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .navigationTitle("Add Medication")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
    
    private func addMedication() {
        let newMedication = Medication(id: UUID().uuidString, name: name, dosage: dosage, time: time)
        viewModel.addMedication(newMedication)
        presentationMode.wrappedValue.dismiss()
    }
}

struct AddMedicationView_Previews: PreviewProvider {
    static var previews: some View {
        AddMedicationView(viewModel: HomeViewModel(coreDataManager: CoreDataManager.preview))
    }
}

