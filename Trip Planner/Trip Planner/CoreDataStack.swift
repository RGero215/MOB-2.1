//
//  CoreDataStack.swift
//  Trip Planner
//
//  Created by Ramon Geronimo on 5/5/19.
//  Copyright © 2019 Ramon Geronimo. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    lazy var managedObjectContext: NSManagedObjectContext = {
        let container = self.persistentContainer
        return container.viewContext
    }()
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "PlannedTrips")
        container.loadPersistentStores() { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error: \(error), \(error.userInfo)")
            }
        }
        return container
    }()
}

extension NSManagedObjectContext {
    func saveChanges() {
        if self.hasChanges {
            do {
                print("Saving...")
                try save()
            } catch {
                fatalError("Error: \(error.localizedDescription)")
            }
        }
    }
}
