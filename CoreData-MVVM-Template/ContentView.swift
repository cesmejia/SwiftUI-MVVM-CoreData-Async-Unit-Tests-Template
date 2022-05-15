//
//  ContentView.swift
//  CoreData-MVVM-Template
//
//  Created by Cesar Mejia Valero on 5/14/22.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var persistenceController: PersistenceController
    
    @StateObject private var viewModel: ViewModel
    
    init(persistenceController: PersistenceController) {
        let viewModel = ViewModel(persistenceController: persistenceController)
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.items) { item in
                    NavigationLink {
                        Text("Item at \(item.timestamp!, formatter: itemFormatter)")
                    } label: {
                        Text(item.timestamp!, formatter: itemFormatter)
                    }
                }
                .onDelete { indexSet in
                    Task {
                        await viewModel.deleteItems(offsets: indexSet)
                    }
                }
            }
            .alert("An error occurred.", isPresented: $viewModel.showErrorAlert) {
                Button("OK") {}
            } message: {
                Text("Please ensure your credentials are correct. Error: \(viewModel.errorMessage)")
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: {
                        Task {
                            await viewModel.addItem(with: Date.now)
                        }
                    }) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            .animation(.default, value: viewModel.items) // replacement for withAnimation not working with Task
            Text("Select an item")
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(persistenceController: PersistenceController.preview)
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(PersistenceController.preview)
    }
}
