//
//  ForgotPasswordViewController.swift
//  VanityPass
//
//  Created by Amit on 12/03/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController {
    @IBOutlet weak var emailTextField : UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func forgotPasswordBtnClicked(_ sender: Any) {
        if !(ValidationManager.validateEmail(email: emailTextField.text!)) {
            showInvalidInputAlert(emailTextField.placeholder!)
        }
        else if Reachability.isConnectedToNetwork() {
            showProgressOnView(self.view)
            let param1:[String:String] = [
                "email": self.emailTextField.text!,
                ]
            print(param1)
            ServerClass.sharedInstance.postRequestWithUrlParameters(param1, path: BASE_URL + PROJECT_URL.FORGOT_PASSWORD_API, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(self.view)
                let success = json["success"].stringValue
                if success  == "true"  {
                    UIAlertController.showInfoAlertWithTitle("Message", message: json["message"].stringValue, buttonTitle: "Okay")
                    self.navigationController?.popViewController(animated: true)
                }
                else {
                    UIAlertController.showInfoAlertWithTitle("Message", message: json["message"].stringValue, buttonTitle: "Okay")
                }
            }, errorBlock: { (NSError) in
                hideAllProgressOnView(self.view)
                UIAlertController.showInfoAlertWithTitle("Alert", message: kUnexpectedErrorAlertString, buttonTitle: "Okay")
                hideAllProgressOnView(self.view)
            })
        }
        else{
            hideAllProgressOnView(self.view)
            UIAlertController.showInfoAlertWithTitle("Alert", message: "Please Check internet connection", buttonTitle: "Okay")
        }
    }
    
    @IBAction func backBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
