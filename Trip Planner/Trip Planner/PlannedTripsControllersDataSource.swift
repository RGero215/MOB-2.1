//
//  PlannedTripsControllersDataSource.swift
//  Trip Planner
//
//  Created by Ramon Geronimo on 5/5/19.
//  Copyright © 2019 Ramon Geronimo. All rights reserved.
//

import UIKit
import CoreData

class PlannedTripsControllersDataSource: NSObject, UITableViewDataSource {
    private let tableView: UITableView
    private let managedObjectContext: NSManagedObjectContext
    
    lazy var fetchedResultsController: TripsFetchResultController = {
        return TripsFetchResultController(managedObjectContext: self.managedObjectContext, tableView: self.tableView)
    }()
    
    init(tableView: UITableView, managedObjectContext: NSManagedObjectContext) {
        self.tableView = tableView
        self.managedObjectContext = managedObjectContext
    }
    
    func object(at indexPath: IndexPath) -> Trips {
        return fetchedResultsController.object(at: indexPath)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = fetchedResultsController.sections?[section] else {return 0}
        return section.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellId", for: indexPath)
        
        return configureCell(cell, at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let trip = fetchedResultsController.object(at: indexPath)
        managedObjectContext.delete(trip)
        managedObjectContext.saveChanges()
    }
    
    private func configureCell(_ cell: UITableViewCell, at indexPath: IndexPath) -> UITableViewCell {
        let trip = fetchedResultsController.object(at: indexPath)
        cell.textLabel?.text = "Trip to \(trip.trip)"
        return cell
    }
    
}
