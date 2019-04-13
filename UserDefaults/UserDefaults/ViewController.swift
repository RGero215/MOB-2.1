//
//  ViewController.swift
//  UserDefaults
//
//  Created by Ramon Geronimo on 4/13/19.
//  Copyright © 2019 Ramon Geronimo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var userDefaults = Defaults()
    var token = "2501u50934u016"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        userDefaults.saveToken(token)
        guard let getToken = userDefaults.getToken().token else {return}
        
        print("""
            
            
            Getting Token: \(getToken)
            
            
            """)
        
        userDefaults.clearUserData()
        guard let deleteToken = userDefaults.getToken().token else {return}
        
        print("""
            
            
            Deleting Token: \(deleteToken)
            
            
            """)
        
        
    }



}

