//
//  HomeView.swift
//  MediTrack
//
//  Created by Oleksandr Matrosov on 15/2/25.
//

import SwiftUI

struct HomeView: View {
    @State private var viewModel: HomeViewModel
    @State private var isAddingMedication = false

    init(viewModel: HomeViewModel = HomeViewModel()) {
        self._viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(viewModel.medications) { med in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(med.name)
                                    .font(.headline)
                                Text("Dosage: \(med.dosage)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            Text(med.time, style: .time)
                                .font(.subheadline)
                                .bold()
                                .foregroundColor(.blue)
                        }
                        .padding(8)
                    }
                    .onDelete { indexSet in
                        if let index = indexSet.first {
                            viewModel.removeMedication(at: index)
                        }
                    }
                }
                .listStyle(PlainListStyle())

                Button(action: {
                    isAddingMedication = true
                }) {
                    Text("+ Add Medication")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding()
                }
            }
            .navigationTitle("MediTrack")
            .sheet(isPresented: $isAddingMedication) {
                AddMedicationView(viewModel: viewModel)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: HomeViewModel(coreDataManager: CoreDataManager.preview))
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
