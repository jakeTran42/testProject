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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FetchCell", for: indexPath) as! FetchCell

        
        let receipt = receipts[indexPath.row]
        
        let amount2 = String(receipt.amount)
        
        cell.nameCellTitle.text = receipt.title
        cell.dateCellTitle.text = receipt.date
        cell.amountCellTitle.text = amount2
        cell.categoryCellTitle.text = receipt.category
        cell.locationcellTitle.text = receipt.location
        cell.descriptionCellTitle.text = receipt.description
        
        if let imageURL = receipt.imageURL {
            let url = NSURL(string: imageURL)
            NSURLSe
        }
        
        return cell
    }
}


