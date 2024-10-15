//
//  Little_LemonApp.swift
//  Little Lemon
//
//  Created by Adrian Eberhardt on 06.10.24.
//

import SwiftUI
import CoreData

@main
struct Little_LemonApp: App {
    // Füge den Persistent Controller hinzu
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            Onboarding()
                // Füge den ManagedObjectContext in die Environment-Variable ein
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
