//
//  EventsTableViewCell.swift
//  VanityPass
//
//  Created by Amit on 06/03/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit

class EventsTableViewCell: UITableViewCell {
   
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var starImgView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
   
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}       
