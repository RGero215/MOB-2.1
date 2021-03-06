//
//  NoWaypointsControllers.swift
//  Trip Planner
//
//  Created by Ramon Geronimo on 5/5/19.
//  Copyright © 2019 Ramon Geronimo. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class NoWaypointsControllers: UIViewController {
    
    var trip: Trips?
    var managedObjectContext: NSManagedObjectContext?
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "You haven't added any waypoints to your trip!"
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var getStarted: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Get Started!", for: .normal)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(handleGetStarted), for: .touchUpInside)
        return button
    }()
    
    var noWaypointStackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let backButton = UIBarButtonItem()
        backButton.title = "Planned Trips"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        guard let trip = self.trip else {return}
        navigationItem.title = "Your Trip: \(trip.trip)"
        setupView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let trip = self.trip else {return}
        if trip.hasWaypoint{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func handleGetStarted(){
        let addWaypoint = AddWaypoint()
        addWaypoint.trip = trip
        addWaypoint.managedObjectContext = self.managedObjectContext
        self.navigationController?.pushViewController(addWaypoint, animated: true)
    }
    
    
    func setupView() {
        noWaypointStackView = UIStackView(arrangedSubviews: [titleLabel, getStarted])
        view.addSubview(noWaypointStackView)
        noWaypointStackView.axis = .vertical
        noWaypointStackView.spacing = 0
        noWaypointStackView.distribution = .fillEqually
        noWaypointStackView.translatesAutoresizingMaskIntoConstraints = false
        
        noWaypointStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        noWaypointStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        noWaypointStackView.heightAnchor.constraint(equalToConstant: CGFloat(100)).isActive = true
        noWaypointStackView.widthAnchor.constraint(equalToConstant: CGFloat(200)).isActive = true
        noWaypointStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        noWaypointStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
    }
}
