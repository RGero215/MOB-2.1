//
//  AddTripControllers.swift
//  Trip Planner
//
//  Created by Ramon Geronimo on 5/5/19.
//  Copyright © 2019 Ramon Geronimo. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class AddTripControllers: UIViewController {
    
    
    var managedObjectContext: NSManagedObjectContext!
    
    let tripNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Give this trip a name!"
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let tripNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Text Field"
        textField.textAlignment = .center
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 0.5
        textField.layer.cornerRadius = 10
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    var tripNameStackview = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "Add Trip"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(handleAdd))
        
        setupView()
        
    }
    
    @objc func handleCancel(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func handleAdd(){
        guard let trip = tripNameTextField.text, !trip.isEmpty else {return}
        let trips = NSEntityDescription.insertNewObject(forEntityName: "Trips", into: managedObjectContext) as! Trips
        trips.trip = trip
        managedObjectContext?.saveChanges()
        navigationController?.popViewController(animated: true)
    }
    
    func setupView() {
        tripNameStackview = UIStackView(arrangedSubviews: [tripNameLabel, tripNameTextField])
        view.addSubview(tripNameStackview)
        tripNameStackview.axis = .vertical
        tripNameStackview.spacing = 0
        tripNameStackview.distribution = .fillEqually
        tripNameStackview.translatesAutoresizingMaskIntoConstraints = false
        
        tripNameStackview.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tripNameStackview.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        tripNameStackview.heightAnchor.constraint(equalToConstant: CGFloat(100)).isActive = true
        tripNameStackview.widthAnchor.constraint(equalToConstant: CGFloat(200)).isActive = true
        tripNameStackview.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        tripNameStackview.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
    }
}
