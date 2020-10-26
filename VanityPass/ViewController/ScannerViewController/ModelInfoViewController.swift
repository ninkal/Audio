//
//  ModelInfoViewController.swift
//  VanityPass
//
//  Created by Amit on 14/03/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit

class ModelInfoViewController: UIViewController {
    @IBOutlet weak var userImageView : UIImageView!
    @IBOutlet weak var userNameLbl : UILabel!
    @IBOutlet weak var eventNameLbl : UILabel!
    @IBOutlet weak var offerNameLbl : UILabel!
    
    var eventDict : NSDictionary!
    var offerDict : NSDictionary!
    var ticketDict: NSDictionary!
    var userDict : NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userImageView.sd_setImage(with:  URL.init(string: IMAGE_URL + "users/" + "\(userDict["profile_pic"]!)"), placeholderImage: #imageLiteral(resourceName: "userImage"))
        userNameLbl.text = "\(userDict["first_name"]!)" + " " + "\(userDict["last_name"]!)"
        eventNameLbl.text = "\(eventDict["name"]!)"
        offerNameLbl.text = "\(offerDict["name"]!)"
    }
    
    @IBAction func verifyBtnTap(_ sender: Any) {
        self.verifyTicketApi()
    }
    
    func verifyTicketApi() {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(self.view)
            let param1:[String:String] = [
                "id": "\(ticketDict["id"]!)",
                "event_id":"\(ticketDict["event_id"]!)",
                "offer_id": "\(ticketDict["event_offer_id"]!)",
                "user_id" : "\(userDict["id"]!)"
            ]
            print(param1)
            ServerClass.sharedInstance.postRequestWithUrlParameters(param1, path: BASE_URL + PROJECT_URL.VERIFY_TICKET_PARTNER_API, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(self.view)
                let success = json["success"].stringValue
                if success  == "true"  {
                    UIAlertController.showInfoAlertWithTitle("Success", message: "Verified Successfully!", buttonTitle: "Okay")
                    let viewControllers: [UIViewController] = self.navigationController!.viewControllers
                    for aViewController in viewControllers {
                        if aViewController is PartnerHomeViewController {
                            self.navigationController!.popToViewController(aViewController, animated: true)
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
        else{
            UIAlertController.showInfoAlertWithTitle("Alert", message: "Please Check internet connection", buttonTitle: "Okay")
        }
    }
}

