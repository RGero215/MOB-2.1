//
//  DetailViewController.swift
//  TodoList
//
//  Created by Ramon Geronimo on 5/4/19.
//  Copyright © 2019 Ramon Geronimo. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController {
    
    var item: Item?
    var context: NSManagedObjectContext?
    
    lazy var todoTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Todo Text"
        textField.layer.cornerRadius = 15.0
        textField.layer.borderWidth = 2.0
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var delete: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Delete", for: .normal)
        button.backgroundColor = .red
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleDelete), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
        if let item = item {
            todoTextField.text = item.text
        }
        setupView()
    }
    
    @objc func handleSave(){
        if let item = item, let newText = todoTextField.text {
            item.text = newText
            context?.saveChanges()
            navigationController?.popViewController(animated: true)
        }
        
    }
    
    @objc func handleDelete(_ sender: UIButton!){
        if let item = item {
            context?.delete(item)
            context?.saveChanges()
            navigationController?.popViewController(animated: true)
        }
    }
    
    func setupView() {
        view.addSubview(todoTextField)
        view.addSubview(delete)
        
        todoTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        todoTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        todoTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        todoTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        todoTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        delete.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        delete.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        delete.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        delete.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    
    
}
