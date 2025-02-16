//
//  MediTrackApp.swift
//  MediTrack
//
//  Created by Oleksandr Matrosov on 16/2/25.
//

import SwiftUI

@main
struct MediTrackApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
