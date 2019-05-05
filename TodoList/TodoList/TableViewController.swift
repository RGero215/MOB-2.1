//
//  TableViewController.swift
//  TodoList
//
//  Created by Ramon Geronimo on 5/3/19.
//  Copyright © 2019 Ramon Geronimo. All rights reserved.
//

import Foundation
import UIKit
import CoreData


class TableViewController: UITableViewController {
    
    
    let managedObjectContext = CoreDataStack().managedObjectContext
    lazy var dataSource: DataSource = {
        return DataSource(tableView: self.tableView, context: self.managedObjectContext)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CellId")
        navigationItem.title = "Todo List"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAdd))
        tableView.dataSource = dataSource
        
    }
    
    @objc func handleAdd(){
        print("Adding...")
        let vc = ViewController()
        vc.managedObjectContext = self.managedObjectContext
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = DetailViewController()

        let item = dataSource.object(at: indexPath)
        detailVC.item = item
        detailVC.context = managedObjectContext
        
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    
}
