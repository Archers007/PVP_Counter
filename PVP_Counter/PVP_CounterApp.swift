//
//  PVP_CounterApp.swift
//  PVP_Counter
//
//  Created by Kieran Bendell on 2023-05-30.
//

import SwiftUI

@main
struct PVP_CounterApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
