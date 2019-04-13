//
//  ViewController.swift
//  Highest Scores
//
//  Created by Ramon Geronimo on 4/3/19.
//  Copyright © 2019 Ramon Geronimo. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    var plist: Plist = Plist(name: "My Plist")!
    var values: [[String: Any]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        navigationItem.title = "Highest Scores"

        do {
            try plist.addValuesToPlistFile(dictionary: data as NSDictionary)
        } catch {
            print("error")
        }
    

        guard let data = plist.getMutablePlistFile() else {return}
        values = data["score"] as! [[String: Any]]
        print("VAlues:", values)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(HighScoreCell.self, forCellReuseIdentifier: "Cell")
        
    }
    
    var data = [
        "firstTime": true,
        "welcomeMessage": "Hello",
        "preferredNumber": 8,
        "score": [
            ["Score": 9, "Name": "Dwight"],
            ["Score": 8, "Name": "Jim"],
            ["Score": 4, "Name": "Pam"],
            ["Score": 2, "Name": "Michael"]
            
        ]
    
        ] as [String : Any]
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return values.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! HighScoreCell
        guard let name = values[indexPath.row]["Name"] else {return cell}
        guard let score = values[indexPath.row]["Score"] else {return cell}
        
        cell.textLabel?.text = "Name: \(name)"
        cell.detailTextLabel?.text = "Score: \(score)"
        
        return cell
    }
    
    
    
        

}

