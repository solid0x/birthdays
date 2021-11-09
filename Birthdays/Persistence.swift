//
//  Persistence.swift
//  Birthdays
//
//  Created by letvarx on 13.10.2021.
//

import CoreData
import Contacts

struct PersistenceController {
    
    static let shared = PersistenceController()
    
    private static let ContainerName = "Main"

    let container: NSPersistentContainer
    var context: NSManagedObjectContext {
        container.viewContext
    }

    private init() {
        container = NSPersistentContainer(name: PersistenceController.ContainerName)
        container.loadPersistentStores(completionHandler: { (description, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
    
    func save() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error occured while saving context: \(error.localizedDescription)")
            }
        }
    }
}
