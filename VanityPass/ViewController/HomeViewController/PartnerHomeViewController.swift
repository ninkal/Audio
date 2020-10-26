//
//  PartnerHomeViewController.swift
//  VanityPass
//
//  Created by Amit on 14/03/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit

class PartnerHomeViewController: UIViewController, closeTransparent {
    func completeOffer(offerId: String) {
        
    }
    
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var searchTextField : UITextField!
    var eventList : [EventStruct] = []
    var searchEventList : [EventStruct] = []
    var timer: Timer? = nil
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.listTableView.tableFooterView = UIView()
        self.getEventListApi()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(true)
//    }
//    
    @IBAction func refreshBtnTap(_ sender: Any) {
        self.getEventListApi()
        searchTextField.text = ""
    }
    
    @IBAction func addNewEventBtnTap(_ sender: Any) {
        let modalViewController = TransParent1ViewController()
        modalViewController.modalPresentationStyle = .overFullScreen // .overCurrentContext
        modalViewController.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
        modalViewController.delegate = self
        self.present(modalViewController, animated: true)
    }
    
    @IBAction func scanOfferBtnTap(_ sender: Any) {
        self.navigationController?.pushViewController(UIStoryboard.scannerViewController(), animated: true)
    }
    
    func getEventListApi() {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(self.view)
            ServerClass.sharedInstance.getRequestWithUrlParameters([:], path: BASE_URL + PROJECT_URL.GET_PARTNER_EVENT_LIST, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(self.view)
                let success = json["success"].stringValue
                if success  == "true"  {
                    sideMenuViewController.hideLeftViewAnimated()
                    self.eventList.removeAll()
                    for i in 0..<json["data"].count {
                        var galleryList : [String] = []
                        for j in 0..<json["data"][i]["galleries"].count {
                            galleryList.append(IMAGE_URL + "events/" + json["data"][i]["galleries"][j].stringValue)
                        }
                        self.eventList.append(EventStruct.init(id: json["data"][i]["id"].stringValue, organiser_name: json["data"][i]["organiser_name"].stringValue, organiser_logo: json["data"][i]["organiser_logo"].stringValue, name: json["data"][i]["name"].stringValue, description: json["data"][i]["description"].stringValue, user_id: json["data"][i]["user_id"].stringValue, address: json["data"][i]["address"].stringValue, latitude: json["data"][i]["latitude"].stringValue, longitude: json["data"][i]["longitude"].stringValue, phone1: json["data"][i]["phone1"].stringValue, phone2: json["data"][i]["phone2"].stringValue, city: json["data"][i]["city"].stringValue, pincode: json["data"][i]["pincode"].stringValue, state: json["data"][i]["state"].stringValue, country: json["data"][i]["country"].stringValue, opening_time: String(json["data"][i]["opening_time"].stringValue.prefix(5)), closing_time: String(json["data"][i]["closing_time"].stringValue.prefix(5)), thumbnail: json["data"][i]["thumbnail"].stringValue, galleries: galleryList, active: json["data"][i]["active"].stringValue, email: "", first_name: "", last_name: "", ticket_available: json["data"][i]["ticket_available"].stringValue, distance: "", timezone: json["data"][i]["timezone"].stringValue))
                    }
                    self.eventList.sort { $0.ticket_available > $1.ticket_available }
                    self.listTableView.reloadData()
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

extension PartnerHomeViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchTextField.text == "" {
            return  self.eventList.count
        }
        else {
            return  self.searchEventList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell") as! HomeTableViewCell
        if searchTextField.text == "" {
            cell.logoImageView.sd_setImage(with: URL(string : IMAGE_URL + "events/" + self.eventList[indexPath.row].organiser_logo), placeholderImage: #imageLiteral(resourceName: "placeholder"))
            cell.nameLbl.text = self.eventList[indexPath.row].name
            cell.statusLbl.text = Int(self.eventList[indexPath.row].ticket_available)! > 0 ? "Available" : "Sold Out"
            cell.statusLbl.textColor = Int(self.eventList[indexPath.row].ticket_available)! > 0 ? UIColor.init(red: 0/255, green: 145/255, blue: 0/255, alpha: 1.0) : UIColor.red
            //        cell.distanceLbl.text = self.eventList[indexPath.row].distance == "" ? "0 Km" : self.eventList[indexPath.row].distance + " KM"
            cell.addressLbl.text = self.eventList[indexPath.row].address
            cell.moreInfoBtn.tag = indexPath.row
            cell.moreInfoBtn.addTarget(self, action: #selector(moreInfoBtnTap), for: .touchUpInside)
        }
        else {
            cell.logoImageView.sd_setImage(with: URL(string : IMAGE_URL + "events/" + self.searchEventList[indexPath.row].organiser_logo), placeholderImage: #imageLiteral(resourceName: "placeholder"))
            cell.nameLbl.text = self.searchEventList[indexPath.row].name
            cell.statusLbl.text = Int(self.searchEventList[indexPath.row].ticket_available)! > 0 ? "Available" : "Sold Out"
            cell.statusLbl.textColor = Int(self.searchEventList[indexPath.row].ticket_available)! > 0 ? UIColor.init(red: 0/255, green: 145/255, blue: 0/255, alpha: 1.0) : UIColor.red
            //        cell.distanceLbl.text = self.eventList[indexPath.row].distance == "" ? "0 Km" : self.eventList[indexPath.row].distance + " KM"
            cell.addressLbl.text = self.searchEventList[indexPath.row].address
            cell.moreInfoBtn.tag = indexPath.row
            cell.moreInfoBtn.addTarget(self, action: #selector(moreInfoBtnTap), for: .touchUpInside)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searchTextField.text == "" {
            let viewController = UIStoryboard.eventDetailsViewController()
            viewController.event = self.eventList[indexPath.row]
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        else {
            let viewController = UIStoryboard.eventDetailsViewController()
            viewController.event = self.searchEventList[indexPath.row]
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 128  
    }
    
    @objc func moreInfoBtnTap(sender: UIButton) {
        if searchTextField.text == "" {
            let viewController = UIStoryboard.eventDetailsViewController()
            viewController.event = self.eventList[sender.tag]
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        else {  
            let viewController = UIStoryboard.eventDetailsViewController()
            viewController.event = self.searchEventList[sender.tag]
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
extension PartnerHomeViewController : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if textField == searchTextField {
            let placeTextFieldStr = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
            timer?.invalidate()
            timer = Timer.scheduledTimer(
                timeInterval: 0.5,
                target: self,
                selector: #selector(getHints),
                userInfo: placeTextFieldStr,
                repeats: false)
        }
        return true
    }
    
    @objc func getHints(timer: Timer) {
        let userInfo = timer.userInfo as! String
        self.searchEventList = self.eventList.filter{ $0.name.lowercased().contains(userInfo.lowercased()) }
        self.listTableView.reloadData()
    }
}
