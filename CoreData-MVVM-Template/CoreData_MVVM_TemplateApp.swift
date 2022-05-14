//
//  CoreData_MVVM_TemplateApp.swift
//  CoreData-MVVM-Template
//
//  Created by Cesar Mejia Valero on 5/14/22.
//

import SwiftUI

@main
struct CoreData_MVVM_TemplateApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
