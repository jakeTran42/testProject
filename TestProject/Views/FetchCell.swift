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
    @IBOutlet weak var cellImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        nameCellTitle.layer.masksToBounds = true
        dateCellTitle.layer.masksToBounds = true
        amountCellTitle.layer.masksToBounds = true
        categoryCellTitle.layer.masksToBounds = true
        locationcellTitle.layer.masksToBounds = true
        descriptionCellTitle.layer.masksToBounds = true
        nameCellTitle.layer.cornerRadius = 8
        dateCellTitle.layer.cornerRadius = 8
        amountCellTitle.layer.cornerRadius = 8
        categoryCellTitle.layer.cornerRadius = 8
        locationcellTitle.layer.cornerRadius = 8
        descriptionCellTitle.layer.cornerRadius = 8
        cellImageView.layer.cornerRadius = cellImageView.frame.size.width/2
        cellImageView.clipsToBounds = true
        
    }
}
