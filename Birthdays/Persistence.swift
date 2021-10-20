//
//  Persistence.swift
//  Birthdays
//
//  Created by letvarx on 13.10.2021.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer
    var context: NSManagedObjectContext {
        container.viewContext
    }

    private init() {
        container = NSPersistentContainer(name: Constants.Persistence.ContainerName)
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

extension PersistenceController {
    func getAllBirthdays() -> [Birthday] {
        let request: NSFetchRequest = Birthday.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            print("Error occured while fetching all birthdays: \(error.localizedDescription)")
            return []
        }
    }
}
