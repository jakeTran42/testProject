//
//  HomeListViewController.swift
//  TestProject
//
//  Created by Jake Tran on 8/4/17.
//  Copyright © 2017 Jake Tran. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase

class HomeListViewController: UITableViewController {
    
    let cellID = "cellID"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "List of Transaction"
        
        fetchUser()
        
    }
    
    func fetchUser() {
        Database.database().reference().child("receipts").child(User.current.uid).observe(.childAdded, with: { (snapshot) in
            print(snapshot)
        })
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellID)
        cell.textLabel?.text = "Something"
        return cell
    }
    
}
