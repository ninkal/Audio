//
//  ServiceAvailabilityTableViewCell.swift
//  Mamnoonak
//
//  Created by Amit on 11/01/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit

class ServiceAvailabilityTableViewCell: UITableViewCell {
    @IBOutlet weak var dayLbl:UILabel!
    @IBOutlet weak var startTimeLbl:UILabel!
    @IBOutlet weak var endTimeLbl:UILabel!
    @IBOutlet weak var editBtn:UIButton!
    @IBOutlet weak var deleteBtn:UIButton! 

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}        
