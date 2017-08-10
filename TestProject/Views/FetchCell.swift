//
//  FetchCell.swift
//  TestProject
//
//  Created by Jake Tran on 8/10/17.
//  Copyright © 2017 Jake Tran. All rights reserved.
//

import Foundation
import UIKit

class FetchCell: UITableViewCell {
    
    @IBOutlet weak var nameCellTitle: UILabel!
    @IBOutlet weak var dateCellTitle: UILabel!
    @IBOutlet weak var amountCellTitle: UILabel!
    @IBOutlet weak var categoryCellTitle: UILabel!
    @IBOutlet weak var locationcellTitle: UILabel!
    @IBOutlet weak var descriptionCellTitle: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.nameCellTitle.layer.cornerRadius = 12
        self.dateCellTitle.layer.cornerRadius = 12
        self.amountCellTitle.layer.cornerRadius = 12
        self.categoryCellTitle.layer.cornerRadius = 12
        self.locationcellTitle.layer.cornerRadius = 12
        self.descriptionCellTitle.layer.cornerRadius = 20
        
    }
}
