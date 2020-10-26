//
//  HomeTableViewCell.swift
//  VanityPass
//
//  Created by chawtech solutions on 4/3/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var distanceLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var moreInfoBtn: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}       
