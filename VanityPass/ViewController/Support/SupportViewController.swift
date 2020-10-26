//
//  SupportViewController.swift
//  VanityPass
//
//  Created by Demo on 05/03/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit

class SupportViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func termsAndConditionBtnTap(_ sender: Any) {
        self.navigationController?.pushViewController(UIStoryboard.privacyPolicyViewController(), animated: true)
    }
    
    @IBAction func contactUsBtnTap(_ sender: Any) {
        self.navigationController?.pushViewController(UIStoryboard.contactUsViewController(), animated: true)
    }
}
