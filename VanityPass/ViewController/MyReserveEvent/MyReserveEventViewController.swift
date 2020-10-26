//
//  SettingsViewController.swift
//  VanityPass
//
//  Created by Demo on 05/03/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit

struct ReservedOfferStruct {
    var id : String = ""
    var event_offer_id : String = ""
    var offer_description : String = ""
    var expire_date : String = ""
    var event_id : String = ""
    var active : String = ""
    var user_first_name : String = ""
    var offer_name : String = ""
    var ticket_id : String = ""
    var user_last_name : String = ""
    var status : String = ""
    var user_email : String = ""
    var qrcode_url : String = ""
    var qr_code_png : String = ""
    var event_name : String = ""
    var is_premium : String = ""
}

class MyReserveEventViewController: UIViewController {
    @IBOutlet weak var customNavigationBar: CustomNavigationBarForDrawer!
    @IBOutlet weak var eventTableView: UITableView!
    var reservedOfferList : [ReservedOfferStruct] = []
    var status : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customNavigationBar.titleLabel.text = "Reserved offers"
        self.eventTableView.tableFooterView = UIView()
        self.eventTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if UserDefaults.standard.bool(forKey: USER_DEFAULTS_KEYS.IS_LOGIN) == true {
           self.getReservedOfferListApi()
        }  
    }
    
    func getReservedOfferListApi() {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(self.view)
            ServerClass.sharedInstance.getRequestWithUrlParameters([:], path: BASE_URL + PROJECT_URL.GET_RESERVED_OFFER_LIST_API, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(self.view)
                let success = json["success"].stringValue
                if success  == "true"  {
                    sideMenuViewController.hideLeftViewAnimated()
                    self.reservedOfferList.removeAll()
                    for i in 0..<json["data"].count {
                        self.reservedOfferList.append(ReservedOfferStruct.init(id: json["data"][i]["id"].stringValue, event_offer_id: json["data"][i]["event_offer_id"].stringValue, offer_description: json["data"][i]["offer_description"].stringValue, expire_date: json["data"][i]["expire_date"].stringValue, event_id: json["data"][i]["event_id"].stringValue,  active: json["data"][i]["active"].stringValue, user_first_name: json["data"][i]["user_first_name"].stringValue, offer_name: json["data"][i]["offer_name"].stringValue, ticket_id: json["data"][i]["ticket_id"].stringValue, user_last_name: json["data"][i]["user_last_name"].stringValue, status: json["data"][i]["status"].stringValue, user_email: json["data"][i]["user_email"].stringValue, qrcode_url: json["data"][i]["qr_code"].stringValue, qr_code_png : json["data"][i]["qr_code_png"].stringValue, event_name : json["data"][i]["event_name"].stringValue, is_premium:  json["data"][i]["is_premium"].stringValue))
                    }
//                    self.reservedOfferList.sort { $0.status < $1.status }  
                    self.eventTableView.reloadData()
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

extension MyReserveEventViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.reservedOfferList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReservedOfferTableViewCell") as! ReservedOfferTableViewCell
        cell.userNameLbl.text = "Venue Name : " + self.reservedOfferList[indexPath.row].event_name
        cell.offerNameLbl.text = "Offer Name : " + self.reservedOfferList[indexPath.row].offer_name
        if self.reservedOfferList[indexPath.row].status == "Verified" {
            cell.statusLbl.text = "Status : Completed"
            cell.statusLbl.textColor = UIColor.init(red: 213/255, green: 4/255, blue: 43/255, alpha: 1.0) 
        }
        else if self.reservedOfferList[indexPath.row].status == "Reserved" {
            cell.statusLbl.text = "Status : Reserved"
            cell.statusLbl.textColor = UIColor.init(red: 0/255, green: 143/255, blue: 0/255, alpha: 1.0)
        }
        else if self.reservedOfferList[indexPath.row].status == "Expire" {
            cell.statusLbl.text = "Status : Expired"
            cell.statusLbl.textColor = UIColor.init(red: 213/255, green: 4/255, blue: 43/255, alpha: 1.0)
        }
        
        cell.expiryDateLbl.text = "Expiry Date : " + self.reservedOfferList[indexPath.row].expire_date

        if self.reservedOfferList[indexPath.row].is_premium == "1" {
            cell.starImgView.isHidden = false
        }
        else {
            cell.starImgView.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = UIStoryboard.eventBarCodeViewController()
        viewController.offerIdStr = self.reservedOfferList[indexPath.row].event_offer_id
        viewController.offerNameStr = self.reservedOfferList[indexPath.row].offer_name
        viewController.offerDescriptionStr = self.reservedOfferList[indexPath.row].offer_description
        viewController.ticketIdStr = self.reservedOfferList[indexPath.row].id
        viewController.eventIdStr = self.reservedOfferList[indexPath.row].event_id
        viewController.barCodeUrlStr = self.reservedOfferList[indexPath.row].qr_code_png
        viewController.barCodeSvgUrlStr = self.reservedOfferList[indexPath.row].qrcode_url
        viewController.statusStr = self.reservedOfferList[indexPath.row].status
        viewController.reserveEventListBool = true
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}        
