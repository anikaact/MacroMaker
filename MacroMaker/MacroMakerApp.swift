//
//  MacroMakerApp.swift
//  MacroMaker
//
//  Created by a on 10/26/24.
//

import SwiftUI

@main
struct MacroMakerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
