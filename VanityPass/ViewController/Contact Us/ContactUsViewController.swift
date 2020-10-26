//
//  ContactUsViewController.swift
//  VanityPass
//
//  Created by Demo on 05/03/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit

class ContactUsViewController: UIViewController {
    @IBOutlet weak var customNavigationBar: CustomNavigationBarForDrawer!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var messageTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        customNavigationBar.titleLabel.text = "Contact Us"
        
        if UserDefaults.standard.bool(forKey: USER_DEFAULTS_KEYS.IS_LOGIN) == true {
            emailTextField.text = UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.USER_EMAIL) as! String
            emailView.isHidden = true
        }
        else {
            emailView.isHidden = false
        }
    }
    
    @IBAction func contactUsBtnTap(_ sender: Any) {
        if !(ValidationManager.validateEmail(email: emailTextField.text!)) {
            showInvalidInputAlert(emailTextField.placeholder!)
        }
        else if (messageTextView.text?.isEmpty)! {
            showInvalidInputAlert("Message")
        }
        else if Reachability.isConnectedToNetwork() {
            showProgressOnView(self.view)
            let param1:[String:String] = [
                "email": emailTextField.text!,
                "message": messageTextView.text!,
                ]
            print(param1)
            ServerClass.sharedInstance.postRequestWithUrlParameters(param1, path: BASE_URL + PROJECT_URL.CONTACT_API, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(self.view)
                let success = json["success"].stringValue
                if success  == "true" {
                    UIAlertController.showInfoAlertWithTitle("Message", message: json["message"].stringValue, buttonTitle: "Okay")
                    self.emailTextField.text = ""
                    self.messageTextView.text = ""  
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
}

extension ContactUsViewController : UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == messageTextView {
            if textView.text == "Message" {
                messageTextView.text = ""
                messageTextView.textColor = UIColor.black
            }
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == messageTextView {
            if textView.text == "" {
                textView.text = "Message"
                messageTextView.textColor = UIColor.darkGray  
            }
        }
    }
}
