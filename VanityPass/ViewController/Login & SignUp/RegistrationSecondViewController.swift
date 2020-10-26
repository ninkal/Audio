//
//  RegistrationSecondViewController.swift
//  VanityPass
//
//  Created by Amit on 05/03/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit

struct ServiceStruct {
    var id : String = ""
    var name : String = ""
}

class RegistrationSecondViewController: UIViewController {
    @IBOutlet weak var fashionBtn: UIButton!
    @IBOutlet weak var foodAndDrinksBtn: UIButton!
    @IBOutlet weak var healthAndFitnessBtn: UIButton!
    @IBOutlet weak var hairAndBeautyBtn: UIButton!
    @IBOutlet weak var homeAndInteriorsBtn: UIButton!
    @IBOutlet weak var travelBtn: UIButton!
    @IBOutlet weak var lifeStyleBtn: UIButton!
    @IBOutlet weak var parentingBtn: UIButton!
    @IBOutlet weak var otherBtn: UIButton!
    @IBOutlet weak var termsOfUseCheckBoxBtn: UIButton!
    @IBOutlet weak var privacyCheckBoxBtn: UIButton!
    @IBOutlet weak var termsOfUseBtn: UIButton!
    @IBOutlet weak var privacyBtn: UIButton!
    @IBOutlet weak var otherTextField: UITextField!

    var serviceList : [ServiceStruct] = []
    var param1 : [String : Any] = [:]
    var userType = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getServiceList()
        self.otherTextField.isHidden = true
    }
    
    @IBAction func backBtnTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
   
    @IBAction func interestBtnTap(_ sender: UIButton) {
        if sender.currentImage == UIImage.init(named: "checkBoxPinkSelected") {
            sender.setImage(UIImage.init(named: "checkBoxPinkUnSelected"), for: .normal)
            if sender.currentTitle == "Other" {
                otherTextField.isHidden = true
            }
        }
        else {
            sender.setImage(UIImage.init(named: "checkBoxPinkSelected"), for: .normal)
            if sender.currentTitle == "Other" {
                otherTextField.isHidden = false
            }
        }
    }
    
    @IBAction func termsOfUseCheckBoxBtnTap(_ sender: UIButton) {
        sender.currentImage == UIImage.init(named: "checkBoxBlackSelected") ? sender.setImage(UIImage.init(named: "checkBoxBlackUnselected"), for: .normal) : sender.setImage(UIImage.init(named: "checkBoxBlackSelected"), for: .normal)
    }
    
    @IBAction func privacyCheckBoxBtnTap(_ sender: UIButton) {
        sender.currentImage == UIImage.init(named: "checkBoxBlackSelected") ? sender.setImage(UIImage.init(named: "checkBoxBlackUnselected"), for: .normal) : sender.setImage(UIImage.init(named: "checkBoxBlackSelected"), for: .normal)
    }
    
    @IBAction func termsOfUseBtnTap(_ sender: UIButton) {
       let viewController = UIStoryboard.termsOfUseViewController()
        viewController.titleStr = "Terms of service"  
        viewController.urlStr = PROJECT_URL.TERMS_OF_USE_API
        self.navigationController?.pushViewController(viewController, animated: true)
      }
    
    @IBAction func privacyBtnTap(_ sender: UIButton) {
        let viewController = UIStoryboard.termsOfUseViewController()
        viewController.titleStr = "Privacy policy"
        viewController.urlStr = PROJECT_URL.PRIVACY_API
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func submitBtnTap(_ sender: Any) {
        var interestList : [String] = []
        for service in self.serviceList {
            if service.name == "Fashion" && fashionBtn.currentImage == UIImage.init(named: "checkBoxPinkSelected") {
                interestList.append(service.id)
            }
            else if service.name == "Food & Drink" && foodAndDrinksBtn.currentImage == UIImage.init(named: "checkBoxPinkSelected") {
                interestList.append(service.id)
            }
            else if service.name == "Health & Fitness" && healthAndFitnessBtn.currentImage == UIImage.init(named: "checkBoxPinkSelected") {
                interestList.append(service.id)
            }
            else if service.name == "Hair & Beauty" && hairAndBeautyBtn.currentImage == UIImage.init(named: "checkBoxPinkSelected") {
                interestList.append(service.id)
            }
            else if service.name == "Home & Interiors" && homeAndInteriorsBtn.currentImage == UIImage.init(named: "checkBoxPinkSelected") {
                interestList.append(service.id)
            }
            else if service.name == "Travel" && travelBtn.currentImage == UIImage.init(named: "checkBoxPinkSelected") {
                interestList.append(service.id)
            }
            else if service.name == "Lifestyle" && lifeStyleBtn.currentImage == UIImage.init(named: "checkBoxPinkSelected") {
                interestList.append(service.id)
            }
            else if service.name == "Parenting" && parentingBtn.currentImage == UIImage.init(named: "checkBoxPinkSelected") {
                interestList.append(service.id)
            }
            else if service.name == "Other" && otherBtn.currentImage == UIImage.init(named: "checkBoxPinkSelected") {
                interestList.append(service.id)
            }
        }
        
        if otherTextField.text != "" {
            interestList.append(otherTextField.text!)
        }
        
        
        if interestList.count == 0 {
            UIAlertController.showInfoAlertWithTitle("Alert", message: String(format:"Please select at least one interest field."), buttonTitle: "Okay")
        }
        else if (otherBtn.currentImage == UIImage.init(named: "checkBoxPinkSelected")) && (otherTextField.text == "") {
            UIAlertController.showInfoAlertWithTitle("Alert", message: String(format:"Please enter interest in other field."), buttonTitle: "Okay")
        }
        else if termsOfUseCheckBoxBtn.currentImage == UIImage.init(named: "checkBoxBlackUnselected") {
            UIAlertController.showInfoAlertWithTitle("Alert", message: String(format:"please accept terms and conditions before proceeding with registration."), buttonTitle: "Okay")
        }
        else if privacyCheckBoxBtn.currentImage == UIImage.init(named: "checkBoxBlackUnselected") {
            UIAlertController.showInfoAlertWithTitle("Alert", message: String(format:"please accept privacy before proceeding with registration."), buttonTitle: "Okay")
        }
        else {
            if Reachability.isConnectedToNetwork() {
                showProgressOnView(self.view)
                if userType == "model" {
                    param1.updateValue(interestList, forKey: "interest")
                    print(param1)
                    ServerClass.sharedInstance.postRequestWithUrlParameters(param1, path: BASE_URL + PROJECT_URL.MODEL_REGISTER_API, successBlock: { (json) in
                        print(json)
                        hideAllProgressOnView(self.view)
                        let success = json["success"].stringValue
                        if success  == "true"  {
                            UIAlertController.showInfoAlertWithTitle("Message", message: json["message"].stringValue, buttonTitle: "Okay")
                            let viewControllers = self.navigationController!.viewControllers as [UIViewController];
                            for aViewController:UIViewController in viewControllers {
                                if aViewController.isKind(of: LoginViewController.self) {
                                    _ = self.navigationController?.popToViewController(aViewController, animated: true)
                                }
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
                else {
                    param1.updateValue(interestList, forKey: "interest")
                    print(param1)
                    ServerClass.sharedInstance.postRequestWithUrlParameters(param1, path: BASE_URL + PROJECT_URL.PARTNER_REGISTER_API, successBlock: { (json) in
                        print(json)
                        hideAllProgressOnView(self.view)
                        let success = json["success"].stringValue
                        if success  == "true"  {
                            UIAlertController.showInfoAlertWithTitle("Message", message: json["message"].stringValue, buttonTitle: "Okay")
                            let viewControllers = self.navigationController!.viewControllers as [UIViewController];
                            for aViewController:UIViewController in viewControllers {
                                if aViewController.isKind(of: LoginViewController.self) {
                                    _ = self.navigationController?.popToViewController(aViewController, animated: true)
                                }
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
            }
            else{
                UIAlertController.showInfoAlertWithTitle("Alert", message: "Please Check internet connection", buttonTitle: "Okay")
            }
        }
    }
    
    func getServiceList() {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(self.view)
            ServerClass.sharedInstance.getRequestWithUrlParameters([:], path: BASE_URL + PROJECT_URL.SERVICE_LIST_API, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(self.view)
                let success = json["success"].stringValue
                if success  == "true"  {
                    for i in 0..<json["data"].count {
                        self.serviceList.append(ServiceStruct.init(id: json["data"][i]["id"].stringValue, name: json["data"][i]["description"].stringValue))
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
}

