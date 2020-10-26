//
//  RegisterOptionViewController.swift
//  VanityPass
//
//  Created by Amit on 05/03/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit

class RegisterOptionViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func backBtnTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)  
    }
    
    @IBAction func modelOrInfluencerNowBtnTap(_ sender: Any) {
        self.navigationController?.pushViewController(UIStoryboard.registerFirstViewController(), animated: true)
    }
    
    @IBAction func partnerBtnTap(_ sender: Any) {
        self.navigationController?.pushViewController(UIStoryboard.registerPartnerFirstViewController(), animated: true)  
    }
}
