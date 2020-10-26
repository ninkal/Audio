//
//  OfferDetailsViewController.swift
//  VanityPass
//
//  Created by Amit on 06/03/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit

struct TimeAvailabilityStruct {
    var id : String = ""
    var event_id : String = ""
    var offer_id : String = ""
    var day : String = ""
    var opening_time : String = ""
    var closing_time : String = ""
}

class OfferDetailsViewController: UIViewController, closeTransparent {
    func completeOffer(offerId: String) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var customNavigationBar: CustomNavigationBar!
    @IBOutlet weak var offerNameLbl: UILabel!
    @IBOutlet weak var offerTagLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var offerExpriationDateLbl: UILabel!
    @IBOutlet weak var frequencyLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var reserveBtn: UIButton!
    @IBOutlet weak var reserveButtonHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var addTimeAvailabilityHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var scrollView : UIScrollView!
    var timeAvailabilityList : [TimeAvailabilityStruct] = []
    
    var activeField: UITextField?
    let datePicker: UIDatePicker = UIDatePicker()
    var event : EventStruct!
    var offer : OfferStruct!
    
    @IBOutlet weak var timeAvailabilityTblView: UITableView!

    @IBOutlet weak var sundaySaveBtn: UIButton!
    @IBOutlet weak var mondaySaveBtn: UIButton!
    @IBOutlet weak var tuesdaySaveBtn: UIButton!
    @IBOutlet weak var wednesdaySaveBtn: UIButton!
    @IBOutlet weak var thursdaySaveBtn: UIButton!
    @IBOutlet weak var fridaySaveBtn: UIButton!
    @IBOutlet weak var saturdaySaveBtn: UIButton!
    
    @IBOutlet weak var sundayStartTimeTextField: UITextField!
    @IBOutlet weak var mondayStartTextField: UITextField!
    @IBOutlet weak var tuesdayStartTextField: UITextField!
    @IBOutlet weak var wednesdayStartTextField: UITextField!
    @IBOutlet weak var thursdayStartTextField: UITextField!
    @IBOutlet weak var fridayStartTextField: UITextField!
    @IBOutlet weak var satrudayStartTextField: UITextField!
    
    @IBOutlet weak var sundayEndTimeTextField: UITextField!
    @IBOutlet weak var mondayEndTimeTextField: UITextField!
    @IBOutlet weak var tuesdayEndTimeTextField: UITextField!
    @IBOutlet weak var wednesdayEndTimeTextField: UITextField!
    @IBOutlet weak var thursdayEndTimeTextField: UITextField!
    @IBOutlet weak var fridayEndTimeTextField: UITextField!
    @IBOutlet weak var satrudayEndTimeTextField: UITextField!
    
    @IBOutlet weak var sundayStartBtn: UIButton!
    @IBOutlet weak var mondayStartBtn: UIButton!
    @IBOutlet weak var tuesdayStartBtn: UIButton!
    @IBOutlet weak var wednesdayStartBtn: UIButton!
    @IBOutlet weak var thursdayStartBtn: UIButton!
    @IBOutlet weak var fridayStartBtn: UIButton!
    @IBOutlet weak var saturdayStartBtn: UIButton!
    
    @IBOutlet weak var sundayEndBtn: UIButton!
    @IBOutlet weak var mondayEndBtn: UIButton!
    @IBOutlet weak var tuesdayEndBtn: UIButton!
    @IBOutlet weak var wednesdayEndBtn: UIButton!
    @IBOutlet weak var thursdayEndBtn: UIButton!
    @IBOutlet weak var fridayEndBtn: UIButton!
    @IBOutlet weak var saturdayEndBtn: UIButton!
    
    var sundayId : String = ""
    var mondayId : String = ""
    var tuesdayId : String = ""
    var wednesdayId : String = ""
    var thursdayId : String = ""
    var fridayId : String = ""
    var saturdayId : String = ""

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        customNavigationBar.titleLabel.text = "Offer Details"
        self.timeAvailabilityTblView.tableFooterView = UIView()
        
        if UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.USER_TYPE) as! String == "model" {
            self.scrollView.isHidden = true
            self.timeAvailabilityTblView.isHidden = false
            self.addTimeAvailabilityHeightConstraints.constant = 0
            self.editBtn.isHidden = true
            if Int(self.offer.ticket_available)! > 0 {
                self.reserveButtonHeightConstraints.constant = 50
            }
            else {
                self.reserveButtonHeightConstraints.constant = 0
            }
            self.statusLbl.text = Int(offer.ticket_available)! > 0 ? "Available" : "Sold Out"
            self.statusLbl.textColor = Int(offer.ticket_available)! > 0 ? UIColor.init(red: 0/255, green: 145/255, blue: 0/255, alpha: 1.0)  : UIColor.red
            self.frequencyLbl.text = ""
            
            let arr : [String] = offer.expire_date.components(separatedBy: " ")
            if arr.count > 0 {
                let dateStr : String = arr[0]
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let date = dateFormatter.date(from: dateStr)
                if date != nil {
                    dateFormatter.dateFormat = "dd-MM-yyyy"
                    let goodDate = dateFormatter.string(from: date!)
                    self.offerExpriationDateLbl.text = "Expire Date: " + goodDate
                    offer.expire_date = goodDate
                }
            }
            
            if Int(offer.ticket_available)! <= 0 {
                self.offerTagLbl.text = "This offer is not available."
            }
            else if offer.frequency == "Daily" {
                self.offerTagLbl.text = "This offer is valid only for today."
            }
            else if offer.frequency == "Weekly" {
                self.offerTagLbl.text = "This offer is valid only for this week."
            }
            else if offer.frequency == "Monthly" {
                self.offerTagLbl.text = "This offer is valid only for this month."
            }
           
            self.sundaySaveBtn.isHidden = true
            self.mondaySaveBtn.isHidden = true
            self.tuesdaySaveBtn.isHidden = true
            self.wednesdaySaveBtn.isHidden = true
            self.thursdaySaveBtn.isHidden = true
            self.fridaySaveBtn.isHidden = true
            self.saturdaySaveBtn.isHidden = true
            
            self.sundayStartTimeTextField.isUserInteractionEnabled = false
            self.mondayStartTextField.isUserInteractionEnabled = false
            self.tuesdayStartTextField.isUserInteractionEnabled = false
            self.wednesdayStartTextField.isUserInteractionEnabled = false
            self.thursdayStartTextField.isUserInteractionEnabled = false
            self.fridayStartTextField.isUserInteractionEnabled = false
            self.satrudayStartTextField.isUserInteractionEnabled = false
            
            self.sundayEndTimeTextField.isUserInteractionEnabled = false
            self.mondayEndTimeTextField.isUserInteractionEnabled = false
            self.tuesdayEndTimeTextField.isUserInteractionEnabled = false
            self.wednesdayEndTimeTextField.isUserInteractionEnabled = false
            self.thursdayEndTimeTextField.isUserInteractionEnabled = false
            self.fridayEndTimeTextField.isUserInteractionEnabled = false
            self.satrudayEndTimeTextField.isUserInteractionEnabled = false
            
            self.sundayStartBtn.isHidden = true
            self.mondayStartBtn.isHidden = true
            self.tuesdayStartBtn.isHidden = true
            self.wednesdayStartBtn.isHidden = true
            self.thursdayStartBtn.isHidden = true
            self.fridayStartBtn.isHidden = true
            self.saturdayStartBtn.isHidden = true
            
            self.sundayEndBtn.isHidden = true
            self.mondayEndBtn.isHidden = true
            self.tuesdayEndBtn.isHidden = true
            self.wednesdayEndBtn.isHidden = true
            self.thursdayEndBtn.isHidden = true
            self.fridayEndBtn.isHidden = true
            self.saturdayEndBtn.isHidden = true
        }
        else {
            self.scrollView.isHidden = false
            self.timeAvailabilityTblView.isHidden = true
            self.offerTagLbl.isHidden = true
            self.statusLbl.text = Int(offer.ticket_available)! > 0 ? "Available" : "Sold Out"
            self.statusLbl.textColor = Int(offer.ticket_available)! > 0 ? UIColor.init(red: 0/255, green: 145/255, blue: 0/255, alpha: 1.0)  : UIColor.red
            self.editBtn.isHidden = false
//            self.addTimeAvailabilityHeightConstraints.constant = 45
            self.reserveButtonHeightConstraints.constant = 0
            self.frequencyLbl.text = offer.frequency
            let arr : [String] = offer.expire_date.components(separatedBy: " ")
          
            if arr.count > 0 {
                let dateStr : String = arr[0]
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let date = dateFormatter.date(from: dateStr)
                if date != nil {
                    dateFormatter.dateFormat = "dd-MM-yyyy"
                    let goodDate = dateFormatter.string(from: date!)
                    self.offerExpriationDateLbl.text = "Expire Date: " + goodDate
                    offer.expire_date = goodDate
                }
            }
        }
        
        self.imgView.sd_setImage(with: URL(string : IMAGE_URL + "events/" + offer.thumbnail), placeholderImage: #imageLiteral(resourceName: "placeholder"))
        self.offerNameLbl.text = offer.name
        self.descriptionLbl.text = offer.description
        
        self.getOfferTimeAvailabilityListApi()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func reserveBtnTap(_ sender: Any) {
        let alert = UIAlertController(title: "Alert", message: "By clicking on the reservation button you agree to post your experience/picture/video on your instagram story, tag the venue & tag @Vanitypass as per terms & condition ", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Okay", style: .default, handler: { (action) in
            if Reachability.isConnectedToNetwork() {
                showProgressOnView(self.view)
                ServerClass.sharedInstance.getRequestWithUrlParameters([:], path: BASE_URL + PROJECT_URL.RESERVE_OFFER_API + "/\(self.event.id)/\(self.offer.id)/\(self.event.timezone.replacingOccurrences(of: "/", with: "0"))", successBlock: { (json) in
                    print(json)
                    hideAllProgressOnView(self.view)
                    let success = json["success"].stringValue
                    if success  == "true"  {
                        UIAlertController.showInfoAlertWithTitle("Message", message: json["message"].stringValue, buttonTitle: "Okay")
                        let viewController = UIStoryboard.eventBarCodeViewController()
                        viewController.event = self.event
                        viewController.eventIdStr = self.event.id
                        viewController.offerIdStr = self.offer.id
                        viewController.offerNameStr = self.offer.name
                        viewController.offerDescriptionStr = self.offer.description
                        viewController.barCodeSvgUrlStr = json["data"]["qrcode"].stringValue
                        viewController.barCodeUrlStr = json["data"]["qr_code_png"].stringValue
                        viewController.reserveEventListBool = false
                        self.navigationController?.pushViewController(viewController, animated: true)
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
        })
        alert.addAction(okAction)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func editBtnTap(_ sender: Any) {
        let modalViewController = TransParent1ViewController()
        modalViewController.modalPresentationStyle = .overFullScreen // .overCurrentContext
        modalViewController.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
        modalViewController.event = self.event
        modalViewController.offer = offer
        modalViewController.delegate = self
        self.present(modalViewController, animated: true)
    }
    
    func getOfferTimeAvailabilityListApi() {
        var urlStr = ""
        if UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.USER_TYPE) as! String == "model" {
            urlStr = PROJECT_URL.GET_MODEL_OFFER_TIME_AVAILABILITY_LIST
        }
        else {
            urlStr = PROJECT_URL.GET_PARTNER_OFFER_TIME_AVAILABILITY_LIST
        }
        
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(self.view)
            ServerClass.sharedInstance.getRequestWithUrlParameters([:], path: BASE_URL + urlStr + "/\(offer.id)", successBlock: { (json) in
                print(json)
                hideAllProgressOnView(self.view)
                let success = json["success"].stringValue
                if success  == "true"  {
                    sideMenuViewController.hideLeftViewAnimated()
                    self.timeAvailabilityList.removeAll()
                    for i in 0..<json["data"].count {
                        self.timeAvailabilityList.append(TimeAvailabilityStruct.init(id: json["data"][i]["id"].stringValue, event_id: json["data"][i]["event_id"].stringValue, offer_id: json["data"][i]["offer_id"].stringValue, day: json["data"][i]["day"].stringValue, opening_time: String(json["data"][i]["opening_time"].stringValue.prefix(5)), closing_time: String(json["data"][i]["closing_time"].stringValue.prefix(5))))
                    }
                    
                    if self.timeAvailabilityList.count == 0 && UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.USER_TYPE) as! String == "model" {
                        self.addTimeAvailabilityHeightConstraints.constant = 0
                    }
                    else {
                        self.addTimeAvailabilityHeightConstraints.constant = 35
                    }
                    
                    if UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.USER_TYPE) as! String == "model" {
                            self.scrollView.isHidden = true
                            self.timeAvailabilityTblView.reloadData()
                    }
                    else {
                        self.timeAvailabilityTblView.isHidden = true
                        for time in self.timeAvailabilityList {
                            if time.day == "Sunday" {
                                self.sundayStartTimeTextField.text = time.opening_time
                                self.sundayEndTimeTextField.text = time.closing_time
                                self.sundaySaveBtn.setTitle("Update", for: .normal)
                                self.sundayId = time.id
                            }
                            else if time.day == "Monday" {
                                self.mondayStartTextField.text = time.opening_time
                                self.mondayEndTimeTextField.text = time.closing_time
                                self.mondaySaveBtn.setTitle("Update", for: .normal)
                                self.mondayId = time.id
                            }
                            else if time.day == "Tuesday" {
                                self.tuesdayStartTextField.text = time.opening_time
                                self.tuesdayEndTimeTextField.text = time.closing_time
                                self.tuesdaySaveBtn.setTitle("Update", for: .normal)
                                self.tuesdayId = time.id
                            }
                            else if time.day == "Wednesday" {
                                self.wednesdayStartTextField.text = time.opening_time
                                self.wednesdayEndTimeTextField.text = time.closing_time
                                self.wednesdaySaveBtn.setTitle("Update", for: .normal)
                                self.wednesdayId = time.id
                            }
                            else if time.day == "Thursday" {
                                self.thursdayStartTextField.text = time.opening_time
                                self.thursdayEndTimeTextField.text = time.closing_time
                                self.thursdaySaveBtn.setTitle("Update", for: .normal)
                                self.thursdayId = time.id
                            }
                            else if time.day == "Friday" {
                                self.fridayStartTextField.text = time.opening_time
                                self.fridayEndTimeTextField.text = time.closing_time
                                self.fridaySaveBtn.setTitle("Update", for: .normal)
                                self.fridayId = time.id
                            }
                            else if time.day == "Saturday" {
                                self.satrudayStartTextField.text = time.opening_time
                                self.satrudayEndTimeTextField.text = time.closing_time
                                self.saturdaySaveBtn.setTitle("Update", for: .normal)
                                self.saturdayId = time.id
                            }
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

//extension OfferDetailsViewController : UITableViewDataSource, UITableViewDelegate {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.timeAvailabilityList.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceAvailabilityTableViewCell") as! ServiceAvailabilityTableViewCell
//        cell.dayLbl.text = "Day : " + self.timeAvailabilityList[indexPath.row].day
//        cell.startTimeLbl.text = "Start Time : " + self.timeAvailabilityList[indexPath.row].opening_time
//        cell.endTimeLbl.text = "End Time : " + self.timeAvailabilityList[indexPath.row].closing_time
//
//        if UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.USER_TYPE) as! String == "model" {
//            cell.editBtn.isHidden = true
//        }
//        else {
//            cell.editBtn.isHidden = false
//        }
//        cell.editBtn.tag = indexPath.row
//        cell.editBtn.addTarget(self, action: #selector(editBtnTap), for: .touchUpInside)
//        cell.deleteBtn.tag = indexPath.row
//        cell.deleteBtn.addTarget(self, action: #selector(deleteBtnTap), for: .touchUpInside)
//        return cell
//    }
//
//    @objc func editBtnTap(sender: UIButton) {
//        self.timeAvailabilityIdStr = self.timeAvailabilityList[sender.tag].id
//
//    }
//
//    @objc func deleteBtnTap(sender: UIButton) {
//
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.USER_TYPE) as! String == "model" {
//            return 88
//        }
//        else {
//            return 120
//        }
//    }
//}

extension OfferDetailsViewController {
//    @IBAction func dayBtnTap(sender: UIButton) {
//        if sender.tag == 1 {
//            self.setupSelectionDropDown(arr: dayList, textfield: self.sundayTextField)
//        }
//        else if sender.tag == 2 {
//            self.setupSelectionDropDown(arr: dayList, textfield: self.mondayTextField)
//        }
//        else if sender.tag == 3 {
//            self.setupSelectionDropDown(arr: dayList, textfield: self.tuesdayTextField)
//        }
//        else if sender.tag == 4 {
//            self.setupSelectionDropDown(arr: dayList, textfield: self.wednesdayTextField)
//        }
//        else if sender.tag == 5 {
//            self.setupSelectionDropDown(arr: dayList, textfield: self.thursdayTextField)
//        }
//        else if sender.tag == 6 {
//            self.setupSelectionDropDown(arr: dayList, textfield: self.fridayTextField)
//        }
//        else if sender.tag == 7 {
//            self.setupSelectionDropDown(arr: dayList, textfield: self.satrudayTextField)
//        }
//    }
    
    @IBAction func startTimeBtnTap(sender: UIButton) {
        if sender.tag == 1 {
            activeField = sundayStartTimeTextField
        }
        else if sender.tag == 2 {
            activeField = mondayStartTextField
        }
        else if sender.tag == 3 {
            activeField = tuesdayStartTextField
        }
        else if sender.tag == 4 {
            activeField = wednesdayStartTextField
        }
        else if sender.tag == 5 {
            activeField = thursdayStartTextField
        }
        else if sender.tag == 6 {
            activeField = fridayStartTextField
        }
        else if sender.tag == 7 {
            activeField = satrudayStartTextField
        }
        self.createDatePicker()
    }
    
    @IBAction func endTimeBtnTap(sender: UIButton) {
        if sender.tag == 1 {
            activeField = sundayEndTimeTextField
        }
        else if sender.tag == 2 {
            activeField = mondayEndTimeTextField
        }
        else if sender.tag == 3 {
            activeField = tuesdayEndTimeTextField
        }
        else if sender.tag == 4 {
            activeField = wednesdayEndTimeTextField
        }
        else if sender.tag == 5 {
            activeField = thursdayEndTimeTextField
        }
        else if sender.tag == 6 {
            activeField = fridayEndTimeTextField
        }
        else if sender.tag == 7 {
            activeField = satrudayEndTimeTextField
        }
        self.createDatePicker()
    }
    
    
//    @IBAction func addTimeAvailabilityBtnTap(_ sender: Any) {
////        timeAvailabilityView.isHidden = false
////        self.dayTextField.text = ""
////        self.startTimeTextField.text = ""
////        self.endTimeTextField.text = ""
////        self.timeAvailabilityIdStr = ""
//    }
    
    @IBAction func saveBtnTap(sender: UIButton) {
        if sender.tag == 1 {
            if (sundayStartTimeTextField.text?.isEmpty)! {
                showInvalidInputAlert(sundayStartTimeTextField.placeholder!)
            }
            else if (sundayEndTimeTextField.text?.isEmpty)! {
                showInvalidInputAlert(sundayEndTimeTextField.placeholder!)
            }
            else {
                self.AddUpdateTimeAvailabilityApi(day: "Sunday", startTime: sundayStartTimeTextField.text!, endTime: sundayEndTimeTextField.text!, timeAvailabilityIdStr: sundayId)
            }
        }
        else if sender.tag == 2 {
            if (mondayStartTextField.text?.isEmpty)! {
                showInvalidInputAlert(mondayStartTextField.placeholder!)
            }
            else if (mondayEndTimeTextField.text?.isEmpty)! {
                showInvalidInputAlert(mondayEndTimeTextField.placeholder!)
            }
            else {
                self.AddUpdateTimeAvailabilityApi(day: "Monday", startTime: mondayStartTextField.text!, endTime: mondayEndTimeTextField.text!, timeAvailabilityIdStr: mondayId)
            }
        }
        else if sender.tag == 3 {
            if (tuesdayStartTextField.text?.isEmpty)! {
                showInvalidInputAlert(tuesdayStartTextField.placeholder!)
            }
            else if (tuesdayEndTimeTextField.text?.isEmpty)! {
                showInvalidInputAlert(tuesdayEndTimeTextField.placeholder!)
            }
            else {
                self.AddUpdateTimeAvailabilityApi(day: "Tuesday", startTime: tuesdayStartTextField.text!, endTime: tuesdayEndTimeTextField.text!, timeAvailabilityIdStr: tuesdayId)
            }
        }
        else if sender.tag == 4 {
            if (wednesdayStartTextField.text?.isEmpty)! {
                showInvalidInputAlert(wednesdayStartTextField.placeholder!)
            }
            else if (wednesdayEndTimeTextField.text?.isEmpty)! {
                showInvalidInputAlert(wednesdayEndTimeTextField.placeholder!)
            }
            else {
                self.AddUpdateTimeAvailabilityApi(day: "Wednesday", startTime: wednesdayStartTextField.text!, endTime: wednesdayEndTimeTextField.text!, timeAvailabilityIdStr: wednesdayId)
            }
        }
        else if sender.tag == 5 {
            if (thursdayStartTextField.text?.isEmpty)! {
                showInvalidInputAlert(thursdayStartTextField.placeholder!)
            }
            else if (thursdayEndTimeTextField.text?.isEmpty)! {
                showInvalidInputAlert(thursdayEndTimeTextField.placeholder!)
            }
            else {
                self.AddUpdateTimeAvailabilityApi(day: "Thursday", startTime: thursdayStartTextField.text!, endTime: thursdayEndTimeTextField.text!, timeAvailabilityIdStr: thursdayId)
            }
        }
        else if sender.tag == 6 {
            if (fridayStartTextField.text?.isEmpty)! {
                showInvalidInputAlert(fridayStartTextField.placeholder!)
            }
            else if (fridayEndTimeTextField.text?.isEmpty)! {
                showInvalidInputAlert(fridayEndTimeTextField.placeholder!)
            }
            else {
                self.AddUpdateTimeAvailabilityApi(day: "Friday", startTime: fridayStartTextField.text!, endTime: fridayEndTimeTextField.text!, timeAvailabilityIdStr: fridayId)
            }
        }
        else if sender.tag == 7 {
            if (satrudayStartTextField.text?.isEmpty)! {
                showInvalidInputAlert(satrudayStartTextField.placeholder!)
            }
            else if (satrudayEndTimeTextField.text?.isEmpty)! {
                showInvalidInputAlert(satrudayEndTimeTextField.placeholder!)
            }
            else {
                self.AddUpdateTimeAvailabilityApi(day: "Saturday", startTime: satrudayStartTextField.text!, endTime: satrudayEndTimeTextField.text!, timeAvailabilityIdStr: saturdayId)
            }
        }
    }
    
    func AddUpdateTimeAvailabilityApi(day:String, startTime:String, endTime: String,timeAvailabilityIdStr: String) {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(self.view)
            var param1 = ["event_id":event.id,
                          "offer_id":offer.id,
                          "day": day,
                          "opening_time":startTime,
                          "closing_time":endTime
            ]
            if timeAvailabilityIdStr == "" {
                print(param1)
                ServerClass.sharedInstance.postRequestWithUrlParameters(param1, path: BASE_URL + PROJECT_URL.ADD_OFFER_TIME_AVAILABILISTY_API, successBlock: { (json) in
                    print(json)
                    hideAllProgressOnView(self.view)
                    let success = json["success"].stringValue
                    if success  == "true"  {
//                        self.timeAvailabilityView.isHidden = true
                        UIAlertController.showInfoAlertWithTitle("Message", message: json["message"].stringValue, buttonTitle: "Okay")
                        self.getOfferTimeAvailabilityListApi()
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
                param1.updateValue(timeAvailabilityIdStr, forKey: "id")
                print(param1)
                ServerClass.sharedInstance.postRequestWithUrlParameters(param1, path: BASE_URL + PROJECT_URL.EDIT_OFFER_TIME_AVAILABILISTY_API, successBlock: { (json) in
                    print(json)
                    hideAllProgressOnView(self.view)
                    let success = json["success"].stringValue
                    if success  == "true" {
//                        self.timeAvailabilityView.isHidden = true
                        UIAlertController.showInfoAlertWithTitle("Message", message: json["message"].stringValue, buttonTitle: "Okay")
                        self.getOfferTimeAvailabilityListApi()
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

extension OfferDetailsViewController {
    func createDatePicker() {
        // Posiiton date picket within a view
        //        if startTimeTextField.text != "" {
        //            datePicker.minimumDate = self.getDateFromString(dateStr:startTimeTextField.text!, formatString: "yyyy-MM-dd HH:mm:ss")!
        //        }
        datePicker.frame = CGRect(x: 10, y: 50, width: self.view.frame.width, height: 220)
        // Set some of UIDatePicker properties
        datePicker.datePickerMode = UIDatePicker.Mode.time
        datePicker.backgroundColor = UIColor.white
        // Add an event to call onDidChangeDate function when value is changed.
        datePicker.addTarget(self, action: #selector(OfferDetailsViewController.datePickerValueChanged(_:)), for: .valueChanged)
        // Add DataPicker to the view
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.backgroundColor = UIColor.black
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(OfferDetailsViewController.donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        activeField?.inputView = datePicker
        activeField?.inputAccessoryView = toolBar
        activeField?.becomeFirstResponder()
    }
    
    //MARK: DatePickerValueChanged Method
    @objc func datePickerValueChanged(_ sender: UIDatePicker){
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let selectedDate = dateFormatter.string(from: sender.date)
        print("Selected value \(selectedDate)")
        activeField?.text = selectedDate
    }
    
    //MARK: Done Picker Method
    @objc func donePicker() {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        activeField?.resignFirstResponder()
        datePicker.removeFromSuperview()
    }
}

extension OfferDetailsViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.timeAvailabilityList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceAvailabilityTableViewCell") as! ServiceAvailabilityTableViewCell
        cell.dayLbl.text = "Day : " + self.timeAvailabilityList[indexPath.row].day
        cell.startTimeLbl.text = "Start Time : " + self.timeAvailabilityList[indexPath.row].opening_time
        cell.endTimeLbl.text = "End Time : " + self.timeAvailabilityList[indexPath.row].closing_time
        
        if UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.USER_TYPE) as! String == "model" {
            cell.editBtn.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.USER_TYPE) as! String == "model" {
            return 88
        }
        else {
            return 120
        }
    }
}
