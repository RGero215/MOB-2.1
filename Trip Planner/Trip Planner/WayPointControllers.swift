//
//  WayPointControllers.swift
//  Trip Planner
//
//  Created by Ramon Geronimo on 5/5/19.
//  Copyright © 2019 Ramon Geronimo. All rights reserved.
//

import Foundation

import UIKit
import CoreData

class WaypointsControllers: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var waypoints: [Waypoints] = []
    var fetchedRC: NSFetchedResultsController<Waypoints>!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if fetchedResultsController.fetchedObjects == [] {
            trip.hasWaypoint = false
            managedObjectContext.saveChanges()
            navigationController?.popViewController(animated: true)
        }
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
        let waypoint = fetchedResultsController.object(at: indexPath)
        cell.textLabel?.text = waypoint.waypoint
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = DetailWaypointController()
        detailVC.trip = self.trip
        detailVC.waypoint = fetchedResultsController.object(at: indexPath)
        self.navigationController?.pushViewController(detailVC, animated: true)
        
    }
    
    lazy var fetchedResultsController: WaypointsFetchResultController = {
        return WaypointsFetchResultController(managedObjectContext: self.managedObjectContext, tableView: self.tableView, fetchRequest: Waypoints.fetchRequest())
    }()
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let waypoint = fetchedResultsController.object(at: indexPath)
        managedObjectContext.delete(waypoint)
        managedObjectContext.saveChanges()
        if fetchedResultsController.fetchedObjects == [] {
            trip.hasWaypoint = false
            managedObjectContext.saveChanges()
            navigationController?.popViewController(animated: true)
        }
    }
    
    
    var trip: Trips!
    var managedObjectContext: NSManagedObjectContext!
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 50)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    lazy var addMoreWaypoints: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Add more waypoints", for: .normal)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(handleAdd), for: .touchUpInside)
        return button
    }()
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    var WaypointStackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let backButton = UIBarButtonItem()
        backButton.title = "Planned Trips"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(handleAdd))
        guard let trip = self.trip else {return}
        navigationItem.title = "Your Trip: \(trip.trip)"
        titleLabel.text = trip.trip
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CellId")
        tableView.delegate = self
        tableView.dataSource = self
        
        var fetch: NSFetchRequest<Waypoints> = fetchedResultsController.fetchRequest
        fetch.predicate = NSPredicate(format: "trip = %@", trip)
        let sort = NSSortDescriptor(key: #keyPath(Waypoints.waypoint), ascending: true)
        fetch.sortDescriptors = [sort]
        do {
            fetchedResultsController = WaypointsFetchResultController(managedObjectContext: managedObjectContext, tableView: tableView, fetchRequest: fetch)
        
            try fetchedResultsController.performFetch()
//            self.waypoints = fetchedRC.fetchedObjects!
            
        } catch {
            fatalError("Error: \(error.localizedDescription)")
        }
        setupView()
        
    }
    
    @objc func handleAdd(){
        let addWaypoint = AddWaypoint()
        addWaypoint.trip = self.trip
        addWaypoint.managedObjectContext = self.managedObjectContext
        self.navigationController?.pushViewController(addWaypoint, animated: true)
    }
    
    
    func setupView() {
        WaypointStackView = UIStackView(arrangedSubviews: [titleLabel, addMoreWaypoints, tableView])
        view.addSubview(WaypointStackView)
        WaypointStackView.axis = .vertical
        WaypointStackView.spacing = 0
        WaypointStackView.distribution = .fillProportionally
        WaypointStackView.translatesAutoresizingMaskIntoConstraints = false
        
        WaypointStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        WaypointStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        WaypointStackView.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
        WaypointStackView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        WaypointStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        WaypointStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        
        titleLabel.heightAnchor.constraint(equalToConstant: CGFloat(200)).isActive = true
        addMoreWaypoints.heightAnchor.constraint(equalToConstant: CGFloat(50)).isActive = true
        tableView.heightAnchor.constraint(equalToConstant: (view.frame.height / 2)).isActive = true
        
    }
}

