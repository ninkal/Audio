//
//  RegisterPartnerFirstViewController.swift
//  VanityPass
//
//  Created by Amit on 14/03/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit
import DropDown

class RegisterPartnerFirstViewController: UIViewController {
    @IBOutlet weak var businessNameTextField: UITextField!
    @IBOutlet weak var contactNameTxtField: UITextField!
    @IBOutlet weak var contactNumberTxtField: UITextField!
    @IBOutlet weak var websiteTextField: UITextField!
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var countryTxtField: UITextField!
    @IBOutlet weak var cityTxtField: UITextField!
    @IBOutlet weak var businessAddressTxtField: UITextField!
    @IBOutlet weak var instagramTxtField: UITextField!
    @IBOutlet weak var facebookTxtField: UITextField!
    @IBOutlet weak var customMessageTxtField: UITextField!
    var countryList : [String] = []
    let dropDown = DropDown()
    var optionsInt = 0
    var fcmKey : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getCountryListApi()
    }
    
    @IBAction func backBtnTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func customizeDropDown(_ sender: AnyObject) {
        let appearance = DropDown.appearance()
        appearance.cellHeight = 60
        appearance.backgroundColor = UIColor(white: 1, alpha: 1)
        appearance.selectionBackgroundColor = UIColor(red: 0.6494, green: 0.8155, blue: 1.0, alpha: 0.2)
        appearance.layer.cornerRadius = 10
        appearance.shadowColor = UIColor(white: 0.6, alpha: 1)
        appearance.shadowOpacity = 0.9
        appearance.shadowRadius = 25
        appearance.animationduration = 0.25
        appearance.textColor = .darkGray
        
        dropDowns.forEach {
            /*** FOR CUSTOM CELLS ***/
            $0.cellNib = UINib(nibName: "MyCell", bundle: nil)
            $0.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
                guard let cell = cell as? MyCell else { return }
                // Setup your custom UI components
                cell.suffixLabel.text = "Suffix \(index)"
            }
            /*** ---------------- ***/
        }
    }
    lazy var dropDowns: [DropDown] = {
        return [
            self.dropDown
        ]
    }()
    
    func setupDropDown(arr:[String],textfield:UITextField) {
        dropDown.anchorView = textfield
        dropDown.bottomOffset = CGPoint(x: 0, y: textfield.bounds.height+10)
        dropDown.dataSource = arr
        dropDown.show()
        dropDown.selectionBackgroundColor = UIColor.lightGray
        dropDown.selectionAction = { [unowned self] (index, item) in
            if textfield == self.countryTxtField {
                self.countryTxtField.text = self.countryList[index]
            }
        }
        dropDown.reloadAllComponents()
    }
    
    @IBAction func countryBtnTap(_ sender: Any) {
        self.setupDropDown(arr: countryList, textfield: self.countryTxtField)
    }
    
    func getCountryListApi() {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(self.view)
            ServerClass.sharedInstance.getRequestWithUrlParameters([:], path: BASE_URL + PROJECT_URL.COUNTRY_LIST_API, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(self.view)
                let success = json["success"].stringValue
                if success  == "true"  {
                    for i in 0..<json["data"].count {
                        self.countryList.append(json["data"][i]["name"].stringValue)
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
    
    @IBAction func nextBtnTap(_ sender: Any) {
        if (businessNameTextField.text?.isEmpty)! {
            showInvalidInputAlert(businessNameTextField.placeholder!)
        }
        else if (contactNameTxtField.text?.isEmpty)! {
            showInvalidInputAlert(contactNameTxtField.placeholder!)
        }
        else if (contactNumberTxtField.text?.isEmpty)! {
            showInvalidInputAlert(contactNumberTxtField.placeholder!)
        }
        else if (websiteTextField.text?.isEmpty)! {
            showInvalidInputAlert(websiteTextField.placeholder!)
        }
        else if !(ValidationManager.validateEmail(email: emailTxtField.text!)) {
            showInvalidInputAlert(emailTxtField.placeholder!)
        }
        else if ValidationManager.validatePassword(password: passwordTxtField.text!) == 0 {
            showPasswordLengthAlert()
        }
        else if ValidationManager.validatePassword(password: passwordTxtField.text!) == 1 {
            showPasswordWhiteSpaceAlert()
        }
        else if (countryTxtField.text?.isEmpty)! {
            showInvalidInputAlert(countryTxtField.placeholder!)
        }
        else if (cityTxtField.text?.isEmpty)! {
            showInvalidInputAlert(cityTxtField.placeholder!)
        }
        else if (businessAddressTxtField.text?.isEmpty)! {
            showInvalidInputAlert(businessAddressTxtField.placeholder!)
        }
        else if (instagramTxtField.text?.isEmpty)! {
            showInvalidInputAlert(instagramTxtField.placeholder!)
        }
        else if (facebookTxtField.text?.isEmpty)! {
            showInvalidInputAlert(facebookTxtField.placeholder!)
        }
        else {
            if let objFcmKey = UserDefaults.standard.object(forKey: USER_DEFAULTS_KEYS.FCM_KEY) as? String {
                self.fcmKey = objFcmKey
            }
            let param1 : [String : Any] = ["company" : businessNameTextField.text!,
                                           "first_name" : contactNameTxtField.text!,
                                           "phone" : contactNumberTxtField.text!,
                                           "website" : websiteTextField.text!,
                                           "email" : emailTxtField.text!,
                                           "password" : passwordTxtField.text!,
                                           "country" : countryTxtField.text!,
                                           "city" : cityTxtField.text!,
                                           "address" : businessAddressTxtField.text!,
                                           "social_facebook_link" : facebookTxtField.text!,
                                           "custom_message" : customMessageTxtField.text!,
                                           "device" : "ios",
                                           "device_id" : (UIDevice.current.identifierForVendor?.uuidString)!,
                                           "fcm_key" : self.fcmKey!]
            let viewController = UIStoryboard.registerSecondViewController()
            viewController.userType = "partner"
            viewController.param1 = param1
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

