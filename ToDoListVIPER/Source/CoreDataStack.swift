//
//  CoreDataStack.swift
//  ToDoListVIPER
//
//  Created by Lucas on 21/04/25.
//

import CoreData
import Foundation

final class CoreDataStack {
    static let shared = CoreDataStack()

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TaskCoreData")
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Erro ao carregar Core Data: \(error)")
            }
        }
        return container
    }()

    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            try? context.save()
        }
    }
}
