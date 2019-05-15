//
//  PlannedTripsControllers.swift
//  Trip Planner
//
//  Created by Ramon Geronimo on 5/5/19.
//  Copyright © 2019 Ramon Geronimo. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class PlannedTripsController: UITableViewController {
    
    var userDefaults = Defaults()
    var token = "2501u50934u016"
    
    let managedObjectContext = CoreDataStack().managedObjectContext
    
    lazy var dataSource: PlannedTripsControllersDataSource = {
        return PlannedTripsControllersDataSource(tableView: self.tableView, managedObjectContext: self.managedObjectContext)
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Planned Trips"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAdd))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CellId")
        tableView.delegate = self
        tableView.dataSource = dataSource
        
        userDefaults.saveToken(token)
        guard let getToken = userDefaults.getToken().token else {return}
        
        print("""
            
            
            Getting Token: \(getToken)
            
            
            """)
        
    }
    
    @objc func handleAdd(){
        let vc = AddTripControllers()
        vc.managedObjectContext = self.managedObjectContext
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let noWaypointsControllers = NoWaypointsControllers()
        let waypointsControllers = WaypointsControllers()
        let trip = dataSource.object(at: indexPath)
        if !trip.hasWaypoint {
            noWaypointsControllers.trip = trip
            noWaypointsControllers.managedObjectContext = self.managedObjectContext
            self.navigationController?.pushViewController(noWaypointsControllers, animated: true)
        } else {
            waypointsControllers.trip = trip
            waypointsControllers.managedObjectContext = self.managedObjectContext
            self.navigationController?.pushViewController(waypointsControllers, animated: true)
        }
        
    }
}
