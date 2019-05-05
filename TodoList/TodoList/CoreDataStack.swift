//
//  CoreDataStack.swift
//  TodoList
//
//  Created by Ramon Geronimo on 5/3/19.
//  Copyright © 2019 Ramon Geronimo. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
//    private(set) lazy var applicationDocumentsDirectory: URL = {
//        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//        let endIndex = urls.index(before: urls.endIndex)
//        return urls[endIndex]
//    }()
//
//    private(set) lazy var managedObjectModel: NSManagedObjectModel = {
//        let modelUrl = Bundle.main.url(forResource: "TodoList", withExtension: "momd")!
//        return NSManagedObjectModel(contentsOf: modelUrl)!
//    }()
//
//    private(set) lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
//        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
//        let url = self.applicationDocumentsDirectory.appendingPathComponent("TodoList.sqlite")
//        do {
//            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url)
//        } catch {
//            print(error)
//            abort()
//        }
//        return coordinator
//    }()
//
//    lazy var manageObjectContext: NSManagedObjectContext = {
//        let coordinator = self.persistentStoreCoordinator
//        let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
//        moc.persistentStoreCoordinator = coordinator
//
//        return moc
//    }()
    
    // This handle all the above code commented out for us
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        let container = self.persistentContainer
        return container.viewContext
    }()
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TodoList")
        container.loadPersistentStores() { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error: \(error), \(error.userInfo)")
            }
        }
        return container
    }()
}

extension NSManagedObjectContext {
    func saveChanges(){
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
