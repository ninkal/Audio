//
//  ViewController.swift
//  VanityPass
//
//  Created by Amit on 05/03/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var userEmailTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    var fcmKey : String?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func forgotPasswordBtnTap(_ sender: Any) {
        self.navigationController?.pushViewController(UIStoryboard.forgotPasswordViewController(), animated: true)
    }
    
    @IBAction func loginBtnTap(_ sender: Any) {
        if !(ValidationManager.validateEmail(email: userEmailTxtField.text!)) {
            showInvalidInputAlert(userEmailTxtField.placeholder!)
        }
        else if ValidationManager.validatePassword(password: passwordTxtField.text!) == 0 {
            showPasswordLengthAlert()
        }
        else if ValidationManager.validatePassword(password: passwordTxtField.text!) == 1 {
            showPasswordWhiteSpaceAlert()
        }
        else if Reachability.isConnectedToNetwork() {
            showProgressOnView(self.view)
            if let objFcmKey = UserDefaults.standard.object(forKey: USER_DEFAULTS_KEYS.FCM_KEY) as? String {
                self.fcmKey = objFcmKey
            }
            let param1:[String:String] = ["email":self.userEmailTxtField.text!,
                                          "password": self.passwordTxtField.text!,
                                          "fcm_key": self.fcmKey!,
                                          "device" : "ios",
                                          "device_id":(UIDevice.current.identifierForVendor?.uuidString)!]
            print(param1)
            ServerClass.sharedInstance.postRequestWithUrlParameters(param1, path: BASE_URL + PROJECT_URL.LOGIN_API, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(self.view)
                let success = json["success"].stringValue
                if success  == "true"  {
                    UserDefaults.standard.set(true, forKey: USER_DEFAULTS_KEYS.IS_LOGIN)
                    UserDefaults.standard.setValue(json["data"]["token"].stringValue, forKey: USER_DEFAULTS_KEYS.LOGIN_TOKEN)
                    UserDefaults.standard.setValue(json["data"]["id"].stringValue, forKey: USER_DEFAULTS_KEYS.USER_ID)
                    UserDefaults.standard.setValue(json["data"]["group_name"].stringValue, forKey: USER_DEFAULTS_KEYS.USER_TYPE)
                    UserDefaults.standard.setValue(json["data"]["profile_pic"].stringValue, forKey: USER_DEFAULTS_KEYS.USER_IMAGE)
                    sideMenuViewController.hideLeftViewAnimated()
                 
                    UserDefaults.standard.setValue(json["data"]["first_name"].stringValue + " " + json["data"]["last_name"].stringValue, forKey: USER_DEFAULTS_KEYS.USER_NAME)
                    UserDefaults.standard.setValue(json["data"]["profile_pic"].stringValue, forKey: USER_DEFAULTS_KEYS.USER_IMAGE)
                    UserDefaults.standard.setValue(json["data"]["email"].stringValue, forKey: USER_DEFAULTS_KEYS.USER_EMAIL)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SIDE_MENU"), object: nil, userInfo: ["sideMeneKey" : true])
                    if json["data"]["group_name"].stringValue == "model" {
                        self.navigationController?.pushViewController(UIStoryboard.modelHomeViewController(), animated: true)
                    }
                    else {
                        self.navigationController?.pushViewController(UIStoryboard.partnerHomeViewController(), animated: true) 
                    }
                }
                else {
                    UIAlertController.showInfoAlertWithTitle("Message", message: json["message"].stringValue, buttonTitle: "Okay")
                }
            }, errorBlock: { (NSError) in
                UIAlertController.showInfoAlertWithTitle("Alert", message: kUnexpectedErrorAlertString, buttonTitle: "Okay")
                hideAllProgressOnView(self.view)
            })  
        }
        else{
            UIAlertController.showInfoAlertWithTitle("Alert", message: "Please Check internet connection", buttonTitle: "Okay")
        }  
    }
    
    @IBAction func applyNowBtnTap(_ sender: Any) {
        self.navigationController?.pushViewController(UIStoryboard.registerOptionViewController1(), animated: true)
    }
    
    @IBAction func leftSideMenuBtnTapped(_ sender: Any) {
        sideMenuViewController.showLeftViewAnimated()
    }
}
