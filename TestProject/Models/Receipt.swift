//
//  Receipt.swift
//  TestProject
//
//  Created by Jake Tran on 8/7/17.
//  Copyright © 2017 Jake Tran. All rights reserved.
//

import Foundation
import FirebaseDatabase

class Receipt {
    var key: String!
    var imageURL: String!
    var title: String!
    var description: String?
    var category: String!
    var date: String!
    var location: String?
    var amount: Double!
    
    init(imageURL: String, title: String, description: String, category: String, date: String, location: String, amount: Double) {
        self.imageURL = imageURL
        self.title = title
        self.amount = amount
        self.description = description
        self.category = category
        self.date = date
        self.location = location
        
    }
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String: Any],
            let titleFromSnapshot = dict["title"] as? String,
            let amount = dict["amount"] as? Double,
            let description = dict["description"] as? String,
            let category = dict["category"] as? String,
            let date = dict["date"] as? String,
            let location = dict["location"] as? String,
            let imageURL = dict["imageURL"] as? String
            else {
                return nil
        }
        self.key = snapshot.key
        self.title = titleFromSnapshot
    }
    
    var dictionaryToPostOnFirebase: [String: Any]? {

        
        return ["title": self.title,
                "imageURL": self.imageURL,
                "description": self.description,
                "category": self.category,
                "date": self.date,
                "location": self.location,
                "amount": self.amount]
    }
    
    
}
