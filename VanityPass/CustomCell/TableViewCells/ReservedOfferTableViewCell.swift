//
//  ReservedOfferTableViewCell.swift
//  VanityPass
//
//  Created by Chawtech on 03/04/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit

class ReservedOfferTableViewCell: UITableViewCell {
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var offerNameLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var expiryDateLbl: UILabel!
    @IBOutlet weak var starImgView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}        
