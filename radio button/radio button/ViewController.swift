//
//  ViewController.swift
//  radio button
//
//  Created by NINKAL GUPTA on 29/11/19.
//  Copyright © 2019 NINKAL GUPTA. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var bntn1: UIButton!
    
    @IBOutlet weak var btn2: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }

    @IBAction func btnAction(_ sender: Any) {
        if btn2.isSelected {
            bntn1.isSelected = true
            btn2.isSelected = false
        }else {
            btn2.isSelected = false
        }
        
        
    }
   
    

    @IBAction func btnAction2(_ sender: Any) {
        
        if bntn1.isSelected {
            bntn1.isSelected = false
            btn2.isSelected = true
        }else {
            bntn1.isSelected = true
        }
        
    }
    
    
}

