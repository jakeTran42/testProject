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

class HomeListViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    var receipts = [Receipt]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        tableView.dataSource = self
        
        fetchData()
        
        //var receipts = Receipt(imageURL: "1", title: "2", description: "3", category: "4", date: "5", location: "6", amount: 44)
    }
    
    func fetchData() {
        Database.database().reference().child("receipts").child(User.current.uid).observe(.childAdded) { (snapshot: DataSnapshot) in
            
            if let dict = snapshot.value as? [String: Any] {
                
                let imageURL = dict["imageURL"] as! String
                let title = dict["title"] as! String
                let description = dict["description"] as! String
                let category = dict["category"] as! String
                let date = dict["date"] as! String
                let location = dict["location"] as! String
                let amount = dict["amount"] as! Double
                
                let receipt = Receipt(imageURL: imageURL, title: title, description: description, category: category, date: date, location: location, amount: amount)
                self.receipts.append(receipt)
                self.tableView.reloadData()
            }
        }
    }
   
}

extension HomeListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return receipts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FetchCell", for: indexPath)
        cell.textLabel?.text = receipts[indexPath.row].title
        return cell
    }
}


