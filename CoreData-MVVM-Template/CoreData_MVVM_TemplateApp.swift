//
//  CoreData_MVVM_TemplateApp.swift
//  CoreData-MVVM-Template
//
//  Created by Cesar Mejia Valero on 5/14/22.
//

import SwiftUI

@main
struct CoreData_MVVM_TemplateApp: App {
    @StateObject var persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView(persistenceController: persistenceController)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(persistenceController)
        }
    }
}
