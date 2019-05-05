//
//  ViewController.swift
//  TodoList
//
//  Created by Ramon Geronimo on 5/3/19.
//  Copyright © 2019 Ramon Geronimo. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    var managedObjectContext: NSManagedObjectContext!
    
    lazy var todoTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Todo Text"
        textField.layer.cornerRadius = 15.0
        textField.layer.borderWidth = 2.0
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        print("presented")
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: nil, action: #selector(handleSave))
        setupView()
    }
    
    @objc func handleCancel(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleSave(){
        guard let text = todoTextField.text, !text.isEmpty else {return}
        let item = NSEntityDescription.insertNewObject(forEntityName: "Item", into: managedObjectContext) as! Item
        item.text = text
        managedObjectContext.saveChanges()
        print("Text: ", text)
        print("Item Text: ", item.text)
        
        dismiss(animated: true, completion: nil)
    }
    
    func setupView() {
        view.addSubview(todoTextField)
        
        todoTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        todoTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        todoTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        todoTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }

}



