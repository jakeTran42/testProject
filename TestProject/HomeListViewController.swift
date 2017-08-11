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
import Kingfisher

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
            
            guard let receipt = Receipt(snapshot: snapshot) else {
                return
            }
            
            self.receipts.append(receipt)
            self.tableView.reloadData()

            
//            if let dict = snapshot.value as? [String: Any] {
//                
//                let imageURL = dict["imageURL"] as! String
//                let title = dict["title"] as! String
//                let description = dict["description"] as! String
//                let category = dict["category"] as! String
//                let date = dict["date"] as! String
//                let location = dict["location"] as! String
//                let amount = dict["amount"] as! Double
//                let key = snapshot.key
//                
//                let receipt = Receipt(key: key, imageURL: imageURL, title: title, description: description, category: category, date: date, location: location, amount: amount)
//
//            }
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
        
        
        let url = URL(string: receipt.imageURL)
        cell.cellImageView.kf.setImage(with: url)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let receiptToDelete = receipts[indexPath.row]
            let key = receiptToDelete.key
            self.receipts.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
            tableView.reloadData()
            let dispatchGroup = DispatchGroup()
            dispatchGroup.enter()
            let firebaseRef = Database.database().reference().child("receipts").child(User.current.uid).child(key!)
            firebaseRef.removeValue(completionBlock: { (err, ref) in
                if err == nil {
                    print("deleted")
                    
                    dispatchGroup.leave()
                    
                }
            })
            
            dispatchGroup.notify(queue: .main, execute: {
            })
            
            
            
//            firebaseRef.queryOrdered(byChild: User.current.uid).queryEqual(toValue: User.current.uid).observe(.childAdded, with: { (snapshot) in
//                
//                snapshot.ref.removeValue(completionBlock: { (Err, ref) in
//                    if Err != nil {
//                        print("Error: \(Err!)")
//                    }
//                })
//            })
        }
        
    }
}


