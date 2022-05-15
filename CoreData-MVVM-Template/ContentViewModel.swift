//
//  ContentViewModel.swift
//  CoreData-MVVM-Template
//
//  Created by Cesar Mejia Valero on 5/14/22.
//

import Foundation
import CoreData

extension ContentView {
    class ViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
        @Published var items = [Item]()
        
        @Published var errorMessage = ""
        @Published var showErrorAlert = false
        
        private let itemsController: NSFetchedResultsController<Item>
        let persistenceController: PersistenceController
        
        init(persistenceController: PersistenceController) {
            self.persistenceController = persistenceController
            
            let request: NSFetchRequest<Item> = Item.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)]
            
            itemsController = NSFetchedResultsController(
                fetchRequest: request,
                managedObjectContext: persistenceController.container.viewContext,
                sectionNameKeyPath: nil,
                cacheName: nil
            )
            
            super.init()
            itemsController.delegate = self
            
            do {
                try itemsController.performFetch()
                items = itemsController.fetchedObjects ?? []
            } catch {
                print("Failed to fetch projects")
            }
        }
        
        @MainActor
        func addItem(with date: Date) async {
            do {
                try await persistenceController.addItem(with: date)
            } catch {
                let nsError = error as NSError
                errorMessage = nsError.localizedDescription
                showErrorAlert = true
            }
        }
        
        @MainActor
        func deleteItems(offsets: IndexSet) async {
            offsets.map { items[$0] }.forEach(persistenceController.delete)

            do {
                try await persistenceController.save()
            } catch {
                let nsError = error as NSError
                errorMessage = nsError.localizedDescription
                showErrorAlert = true
            }
        }
        
        func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            if let newItems = controller.fetchedObjects as? [Item] {
                items = newItems
            }
        }
    }
}
