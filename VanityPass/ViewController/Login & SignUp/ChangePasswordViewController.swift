//
//  ChangePasswordViewController.swift
//  Amistos
//
//  Created by chawtech solutions on 4/13/18.
//  Copyright © 2018 chawtech solutions. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var customNavigationBar: CustomNavigationBarForDrawer!
    @IBOutlet weak var oldPasswordTxtField: UITextField!
    @IBOutlet weak var newPasswordTxtField: UITextField!
    @IBOutlet weak var confirmPasswordTxtField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customNavigationBar.titleLabel.text = "Change Password"
    }
    
    @IBAction func submitBtnTap(_ sender: Any) {
        if (oldPasswordTxtField.text?.isEmpty)! {
            showInvalidInputAlert(oldPasswordTxtField.placeholder!)
        }
        else if (newPasswordTxtField.text?.isEmpty)! {
            showInvalidInputAlert(newPasswordTxtField.placeholder!)
        }
        else if (confirmPasswordTxtField.text?.isEmpty)! {
            showInvalidInputAlert(confirmPasswordTxtField.placeholder!)
        }
        else if oldPasswordTxtField.text == newPasswordTxtField.text {
            showPasswordEqualAlert()
        }
        else if newPasswordTxtField.text != confirmPasswordTxtField.text {
            showPasswordUnEqualAlert()
        }
        else {
            self.changePasswordApi()
        }
    }
    
    func changePasswordApi(){
        if Reachability.isConnectedToNetwork() {
            var urlStr : String = ""
            if UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.USER_TYPE) as! String == "model" {
                urlStr = PROJECT_URL.CHANGE_PASSWORD_MODEL_API
            }
            else {
                urlStr = PROJECT_URL.CHANGE_PASSWORD_PARTNER_API
            }
            
            let param1:[String:String] = ["old_password": oldPasswordTxtField.text!,
                                          "new_password": newPasswordTxtField.text!,
                                          "confirm_password" : confirmPasswordTxtField.text!
            ]
            print(param1)
            showProgressOnView(self.view)
            ServerClass.sharedInstance.postRequestWithUrlParameters(param1, path: BASE_URL + urlStr, successBlock: { (json) in
                hideAllProgressOnView(self.view)
                print(json)  
                let success = json["success"].stringValue
                if success  == "true"  {
                    UIAlertController.showInfoAlertWithTitle("Alert", message:json["message"].stringValue, buttonTitle: "Okay")
//                    self.navigationController?.popViewController(animated: true)      
                  }
                else {
                    hideAllProgressOnView(self.view)
                    UIAlertController.showInfoAlertWithTitle("Alert", message:json["message"].stringValue, buttonTitle: "Okay")
                }
            }, errorBlock: { (NSError) in
                UIAlertController.showInfoAlertWithTitle("Alert", message: NSError.localizedDescription, buttonTitle: "Okay")
                hideAllProgressOnView(self.view)
            })
        }
        else{
            hideAllProgressOnView(self.view)
            UIAlertController.showInfoAlertWithTitle("Alert", message: "Please Check internet connection", buttonTitle: "Okay")
        }
    }
}
