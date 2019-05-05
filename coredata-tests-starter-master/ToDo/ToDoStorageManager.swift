//
//  ToDoStorageManager.swift
//  ToDo
//
//  Created by Adriana González Martínez on 4/29/19.
//  Copyright © 2019 Adriana González Martínez. All rights reserved.
//

import Foundation
import CoreData
import UIKit

// Class that is in charge of communicating with Core Data.
class ToDoStorageManager {
    
    // All changes made to the database, we'll do them in a background thread instead of main thread, so we create a new context to work in the background.
    lazy var backgroundContext: NSManagedObjectContext = {
        return self.persistentContainer.newBackgroundContext()
    }()
    
    // Needs a persistence container to interact with Core Data
    let persistentContainer: NSPersistentContainer!
    
    // Init method showing how the class depends on the container.
    init(container: NSPersistentContainer) {
        self.persistentContainer = container
        self.persistentContainer.viewContext.automaticallyMergesChangesFromParent = true //to receive changes from other contexts.
    }
    
    convenience init() {
        // This init uses the regular container for production.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Can't get AppDelegate reference.")
        }
        self.init(container: appDelegate.persistentContainer)
    }
    
    //MARK: CRUD
    
    // Creating items
    func insertTodoItem( name: String, completed: Bool ) -> Item? {
        
        guard let toDoItem = NSEntityDescription.insertNewObject(forEntityName: "Item", into: backgroundContext) as? Item else { return nil }
        toDoItem.name = name
        toDoItem.completed = completed
        
        return toDoItem
    }
    
    // Gets all the items stored
    func fetchAllItems() -> [Item] {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        let results = try? persistentContainer.viewContext.fetch(request)
        return results ?? [Item]()
    }
    
    // Removes an item with a specified Id
    func removeItem( objectID: NSManagedObjectID ) {
        let obj = backgroundContext.object(with: objectID)
        backgroundContext.delete(obj)
    }
    
    // Saves all the changes
    func save() {
        if backgroundContext.hasChanges {
            do {
                try backgroundContext.save()
            } catch {
                print(error)
            }
        }
        
    }
}
