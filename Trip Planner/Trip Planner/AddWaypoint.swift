//
//  AddWaypoint.swift
//  Trip Planner
//
//  Created by Ramon Geronimo on 5/5/19.
//  Copyright © 2019 Ramon Geronimo. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class AddWaypoint: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellId", for: indexPath)
        cell.textLabel?.text = "trips"
        return cell
    }
    
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .prominent
        searchBar.isTranslucent = false
        searchBar.delegate = self
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        return searchBar
    }()
    
    lazy var mapView: MKMapView = {
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        let width = view.frame.size.width
        let height = view.frame.size.height / 2 - 100
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.dataSource = self
        return table
    }()
    
    var stackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "Add Waypoint"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CellId")
        
        setupview()
    }
    
    @objc func handleCancel(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func handleSave(){
        
    }
    
    func setupview(){
        let width = view.frame.size.width
        let height = view.frame.size.height
        
        stackView = UIStackView(arrangedSubviews: [searchBar, tableView, mapView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 0
        stackView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        
        stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        searchBar.heightAnchor.constraint(equalToConstant: 44).isActive = true
        tableView.heightAnchor.constraint(equalToConstant: (view.frame.height / 2) + 44).isActive = true
        mapView.heightAnchor.constraint(equalToConstant: view.frame.height / 2).isActive = true
        
    
    }

}
