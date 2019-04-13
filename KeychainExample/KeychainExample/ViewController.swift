//
//  ViewController.swift
//  KeychainExample
//
//  Created by Ramon Geronimo on 4/10/19.
//  Copyright © 2019 Ramon Geronimo. All rights reserved.
//

import UIKit
import KeychainSwift

class ViewController: UIViewController, UIScrollViewDelegate {
    
    let keychain = KeychainSwift()
    
    lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.text = "Save a message"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let textField: UITextField = {
        let textField = CustomTextField()
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor.white
        textField.font = UIFont.boldSystemFont(ofSize: 14)
        textField.textColor = .black
        textField.attributedPlaceholder = NSAttributedString(string: "message goes here", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        textField.textAlignment = .center
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
        return button
    }()
    
    let syncWithICloudLabel: UILabel = {
        let label = UILabel()
        label.text = "Will it sync with iCloud?"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var toggleOnOff: UISwitch = {
        let toggle = UISwitch()
        toggle.translatesAutoresizingMaskIntoConstraints = false
        toggle.addTarget(self, action: #selector(handleToggle), for: .touchUpInside)
        return toggle
    }()
    
    let emptySpace: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let currentMessageTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "The current message is:"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let currentMessageLabel: UILabel = {
        let label = UILabel()
        label.text = "..."
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Delete", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleDelete), for: .touchUpInside)
        return button
    }()
    
    var horizontalStackView = UIStackView()
    var verticalStackView = UIStackView()
    
//    lazy var scrollView: UIScrollView = {
//        let v = UIScrollView()
//        v.translatesAutoresizingMaskIntoConstraints = false
//        return v
//    }()
//
//    lazy var contentView:UIView = {
//        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
    
//    override func viewDidLayoutSubviews() {
//        scrollView.delegate = self
//        scrollView.contentSize = CGSize(width:self.view.frame.size.width, height: 1000) // set height according you
//        scrollView.delaysContentTouches = false
//        scrollView.isUserInteractionEnabled = true
//
//    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.white
        navigationItem.title = "Keychain Demo"
        setupView()
    }
    
    func setupView(){
        
//        // add the scroll view to self.view
//        view.addSubview(scrollView)
//        scrollView.addSubview(contentView)
//
//
//
//
//        // constrain the scroll view to 8-pts on each side
//        scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
//        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//
//        contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
//        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
//        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
//        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        
        view.addSubview(messageLabel)
        view.addSubview(textField)
        view.addSubview(saveButton)
        
    
        messageLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100).isActive = true
        messageLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -10).isActive = true
        messageLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10).isActive = true
        
        textField.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 40).isActive = true
        textField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20).isActive = true
        textField.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20).isActive = true
        
        saveButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 40).isActive = true
        saveButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        saveButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        
        
        horizontalStackView = UIStackView(arrangedSubviews: [syncWithICloudLabel, emptySpace, toggleOnOff])
        view.addSubview(horizontalStackView)
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        horizontalStackView.axis = .horizontal
        horizontalStackView.spacing = 10
        horizontalStackView.distribution = .equalCentering
        horizontalStackView.layer.borderColor = UIColor.lightGray.cgColor
        horizontalStackView.layer.borderWidth = 2
        horizontalStackView.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 40).isActive = true
        horizontalStackView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20).isActive = true
        horizontalStackView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20).isActive = true
        
        verticalStackView = UIStackView(arrangedSubviews: [currentMessageTitleLabel, currentMessageLabel, deleteButton])
        view.addSubview(verticalStackView)
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 60
        verticalStackView.distribution = .fillEqually
        verticalStackView.layer.borderColor = UIColor.lightGray.cgColor
        verticalStackView.layer.borderWidth = 2
        verticalStackView.topAnchor.constraint(equalTo: horizontalStackView.bottomAnchor, constant: 100).isActive = true
        verticalStackView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20).isActive = true
        verticalStackView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20).isActive = true
        verticalStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
  
    }

    @objc func handleSave() {
        print("Saving...")
        guard let message = textField.text else {return}
        keychain.set(message, forKey: "message", withAccess: .accessibleWhenUnlocked)
        currentMessageLabel.text = keychain.get("message")
        textField.text = ""
        textField.resignFirstResponder()
    }
    
    
    
    @objc func handleDelete() {
        print("Deleting...")
        keychain.delete("message")
        currentMessageLabel.text = keychain.get("message")
    }
    
    @objc func handleToggle(_ sender: UISwitch) {
        if sender.isOn {
            keychain.synchronizable = true
            print("synchronizable")
        } else {
            keychain.synchronizable = false
            print("not synchronizable")
        }
    }

}

