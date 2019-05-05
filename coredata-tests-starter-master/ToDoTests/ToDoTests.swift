//
//  ToDoTests.swift
//  ToDoTests
//
//  Created by Adriana González Martínez on 4/29/19.
//  Copyright © 2019 Adriana González Martínez. All rights reserved.
//

import XCTest
import CoreData

@testable import ToDo

class ToDoTests: XCTestCase {

    // Custom managedObjectModel that will be used to initialize the persistent container.
    // The model object is created from test Bundle. For this to be possible, the model should also be added to the test target. I did this part in advance, so don't worry about it.
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle(for: type(of: self))] )!
        return managedObjectModel
    }()
    
    // Variable that holds an instane of the ToDoStorageManager
    var manager: ToDoStorageManager!
    
    // Mock Persistence container we'll use for the tests.
    // A default container will use a store of type NSSQLLiteStoreType
    // In this case we want to use the NSInMemoryStoreType, because we don't want to save our mock items to th real database.
    // In the in-memory database we can fake all the regular management of items without worrying about the real data.
    
    lazy var mockPersistantContainer: NSPersistentContainer = {
        // Initializing a container with a specified managedObjectModel
        let container = NSPersistentContainer(name: "ToDo", managedObjectModel: self.managedObjectModel)
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType // where we set the type
        description.shouldAddStoreAsynchronously = false
        
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { (description, error) in
            // Check if the data store is in memory
            precondition( description.type == NSInMemoryStoreType )
            
            // Check for errors
            if let error = error {
                fatalError("Something went wrong, \(error)")
            }
        }
        return container
    }()

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        
        // TODO: create mock items for the tests
        createMockItems()
        
        // TODO: instantiate  the manager and inject the mockPersistantcontainer as the needed dependency.
        manager = ToDoStorageManager(container: mockPersistantContainer)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        // TODO: Clear all mock data

        super.tearDown()
    }
    
    //TODO: Check that created item is not nil
    func test_create_todo() {
        var name = "Ramon"
        var completionStatus = false
        
        var item = manager.insertTodoItem(name: name, completed: completionStatus)
        XCTAssertNotNil(item)
       
        
    }
    
    // TODO: Check that you get the correct amount of items
    func test_fetch_all_todo() {
        
        
        var items = manager.fetchAllItems()
        XCTAssertEqual(items.count, itemsTotalCount())
        
        
    }
    
    //TODO: Check that you get the correct amount of items after deleting one
    func test_remove_todo() {
        
        var item = manager.fetchAllItems()
        manager.removeItem(objectID: (item.first?.objectID)!)
        
        
        
        XCTAssertEqual(item.count, itemsTotalCount())
      
        
    }

    func createMockItems() {
        
        func insertTodoItem( name: String, completed: Bool ) -> Item? {
            let obj = NSEntityDescription.insertNewObject(forEntityName: "Item", into: mockPersistantContainer.viewContext)
            
            obj.setValue(name, forKey: "name")
            obj.setValue(completed, forKey: "completed")
            
            return obj as? Item
        }
        
        //TODO: Create a few items, ignore the unused warning you'll get. This items are also called stubs.
        var itemOne = insertTodoItem(name: "valueOne", completed: true)
        var itemTwo = insertTodoItem(name: "valueTwo", completed: false)
        var itemThree = insertTodoItem(name: "valueThree", completed: true)
        
        
        // Saving the context, to really save the items you just created.
        
        do {
            try mockPersistantContainer.viewContext.save()
        }  catch {
            print("create fakes error \(error)")
        }
        
    }
    
    // Helper method to clear the data
    func clearData() {
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")
        let objs = try! mockPersistantContainer.viewContext.fetch(fetchRequest)
        for case let obj as NSManagedObject in objs {
            mockPersistantContainer.viewContext.delete(obj)
        }
        try! mockPersistantContainer.viewContext.save()
        
    }
    
    // Helper method to count items in the store
    func itemsTotalCount() -> Int {
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Item")
        let results = try! mockPersistantContainer.viewContext.fetch(request)
        return results.count
    }
}
