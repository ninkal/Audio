//
//  EventBarCodeViewController.swift
//  VanityPass
//
//  Created by Amit on 06/03/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit
import CoreLocation

class EventBarCodeViewController: UIViewController, UIGestureRecognizerDelegate {
    @IBOutlet weak var customNavigationBar: CustomNavigationBar!
    @IBOutlet weak var barCodeImageView: UIImageView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var offerNameLbl: UILabel!
    @IBOutlet weak var bottomBtn: UIButton!
    @IBOutlet weak var offerDescriptionLbl: UILabel!
    @IBOutlet weak var timeAvailabilityTblView: UITableView!
    @IBOutlet weak var timeAvailabilityTitleView: UIView!
    @IBOutlet weak var scrollViewHeightConstranints: NSLayoutConstraint!
    @IBOutlet weak var cancelReservationBtnHeightConstraints: NSLayoutConstraint!
    var timeAvailabilityList : [TimeAvailabilityStruct] = []
    var event : EventStruct!
    var eventIdStr : String = ""
    var offerNameStr : String = ""
    var offerIdStr : String = ""
    var offerDescriptionStr : String = ""
    var ticketIdStr : String = ""
    var reserveEventListBool : Bool = false
    var barCodeUrlStr = ""
    var barCodeSvgUrlStr = ""
    var eventName : String = ""
    var eventDistance : String = ""
    var eventLatitude : String = ""
    var eventLongitude :  String = ""
    var locationManager = CLLocationManager()
    var currentLatitude = CLLocationDegrees()
    var currentLongitude = CLLocationDegrees()
    var statusStr : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        offerNameLbl.text = offerNameStr
        offerDescriptionLbl.text = offerDescriptionStr
        locationManager.delegate = self
        initializeTheLocationManager()
        self.timeAvailabilityTblView.tableFooterView = UIView()

        if statusStr == "Verified" || statusStr == "Expire" {
            self.cancelReservationBtnHeightConstraints.constant = 0
        }
        self.barCodeImageView!.sd_setImage(with: URL(string: IMAGE_URL + "qrcodes/" + barCodeUrlStr),  placeholderImage: #imageLiteral(resourceName: "placeholder"))
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(barCodeImageViewTap(_:)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        tapGesture.delegate = self
        self.barCodeImageView.addGestureRecognizer(tapGesture)
        
//        self.getEventDetailsApi()
        
        if reserveEventListBool == false {
            bottomBtn.setTitle("Done", for: .normal)
        }
        else {
            bottomBtn.setTitle("CANCEL RESERVATION", for: .normal)
        }
        self.getOfferTimeAvailabilityListApi()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        segmentedControl.selectedSegmentIndex = 0
    }
 
    @objc func barCodeImageViewTap(_ sender: UITapGestureRecognizer) {
        let viewController = UIStoryboard.qrCodeImageViewController()
        viewController.barCodePngUrlStr = self.barCodeUrlStr
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func segmentClicked(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex {
        case 0: break
        case 1:
            let viewController = UIStoryboard.venueViewController()
            viewController.event = event
            viewController.eventName = eventName
            viewController.eventDistance = eventDistance
            viewController.eventLatitude = eventLatitude
            viewController.eventLongitude = eventLongitude
            self.navigationController?.pushViewController(viewController, animated: true)
            break
        default:break;
        }
    }
    
    @IBAction func bottomBtnTap(_ sender: Any) {
        if bottomBtn.currentTitle == "Done" {
            for controller in self.navigationController!.viewControllers as Array {
                if controller.isKind(of: ModelHomeViewController.self) {
                    self.navigationController!.popToViewController(controller, animated: true)
                    break
                }
            }
        }
        else {
            let alert = UIAlertController(title: String(format:"Are you sure you want to cancel %@ offer?",offerNameStr), message: nil, preferredStyle: .alert)
            let noAction = UIAlertAction(title: "No", style: .cancel, handler: { (action) in })
            let yesAction = UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                self.cancelReservedOfferApi()
            })
            alert.addAction(noAction)
            alert.addAction(yesAction)
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func getEventDetailsApi() {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(self.view)
            if UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.USER_TYPE) as! String == "model" {
                let param1 = ["id":eventIdStr,
                              "latitude": "\(currentLatitude)",
                              "longitude": "\(currentLongitude)"
//                    "latitude":"28.53551610",
//                    "longitude":"77.39102650",
                ]
                print(param1)
                ServerClass.sharedInstance.postRequestWithUrlParameters(param1, path: BASE_URL + PROJECT_URL.GET_MODEL_EVENT_DETAILS, successBlock: { (json) in
                    print(json)
                    hideAllProgressOnView(self.view)
                    let success = json["success"].stringValue
                    if success  == "true"  {
                        self.eventName  = json["data"]["name"].stringValue
                        self.eventDistance  = json["data"]["distance"].stringValue
                        self.eventLatitude = json["data"]["latitude"].stringValue
                        self.eventLongitude = json["data"]["longitude"].stringValue
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
                ServerClass.sharedInstance.getRequestWithUrlParameters([:], path: BASE_URL + PROJECT_URL.GET_PARTNER_EVENT_DETAILS + "/\(eventIdStr)", successBlock: { (json) in
                    print(json)
                    hideAllProgressOnView(self.view)
                    let success = json["success"].stringValue
                    if success  == "true"  {
                        self.eventName  = json["data"]["name"].stringValue
                        self.eventDistance  = json["data"]["distance"].stringValue
                        self.eventLatitude = json["data"]["latitude"].stringValue
                        self.eventLongitude = json["data"]["longitude"].stringValue
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
    
    func getOfferTimeAvailabilityListApi() {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(self.view)
            ServerClass.sharedInstance.getRequestWithUrlParameters([:], path: BASE_URL + PROJECT_URL.GET_MODEL_OFFER_TIME_AVAILABILITY_LIST + "/\(offerIdStr)", successBlock: { (json) in
                print(json)
                hideAllProgressOnView(self.view)
                let success = json["success"].stringValue
                if success  == "true"  {
                    self.timeAvailabilityList.removeAll()
                    for i in 0..<json["data"].count {
                        self.timeAvailabilityList.append(TimeAvailabilityStruct.init(id: json["data"][i]["id"].stringValue, event_id: json["data"][i]["event_id"].stringValue, offer_id: json["data"][i]["offer_id"].stringValue, day: json["data"][i]["day"].stringValue, opening_time: String(json["data"][i]["opening_time"].stringValue.prefix(5)), closing_time: String(json["data"][i]["closing_time"].stringValue.prefix(5))))
                    }
                    
//                    UIView.animate(withDuration: 0, delay: 0, options: .curveEaseInOut, animations: {() -> Void in
//                        self.timeAvailabilityTblView.isScrollEnabled = false
//                        self.timeAvailabilityTblView.reloadData()
//                        self.timeAvailabilityTblView.layoutIfNeeded()
//                    }, completion: {(_ finished: Bool) -> Void in
//                        var tableFrame = self.timeAvailabilityTblView.frame
//                        tableFrame.size.height = self.timeAvailabilityTblView.contentSize.height
//                        tableFrame.size.width = self.timeAvailabilityTblView.contentSize.width
//                        if self.timeAvailabilityList.count > 0 {
//                            self.scrollViewHeightConstranints.constant =  self.scrollViewHeightConstranints.constant - 150 + tableFrame.size.height
//                            self.timeAvailabilityTitleView.isHidden = false
//                        }
//                        else {
//                            self.scrollViewHeightConstranints.constant =  self.scrollViewHeightConstranints.constant - 150 - 45
//                            self.timeAvailabilityTitleView.isHidden = true
//                        }
//                    })
                    
                    
                    UIView.animate(withDuration: 0, delay: 0, options: .curveEaseInOut, animations: {() -> Void in
                        self.timeAvailabilityTblView.isScrollEnabled = false
                        self.timeAvailabilityTblView.reloadData()
                        self.timeAvailabilityTblView.layoutIfNeeded()
                    }, completion: {(_ finished: Bool) -> Void in
                        //                        var tableFrame = self.timeAvailabilityTblView.frame
                        //                        tableFrame.size.height = self.timeAvailabilityTblView.contentSize.height
                        //                        tableFrame.size.width = self.timeAvailabilityTblView.contentSize.width
                        if self.timeAvailabilityList.count > 0 {
                            let height : Int = 88 * self.timeAvailabilityList.count
                            self.scrollViewHeightConstranints.constant = CGFloat(390 - 150 + height)  //tableFrame.size.height
                            self.timeAvailabilityTitleView.isHidden = false
                        }
                        else {
                            self.scrollViewHeightConstranints.constant = 390 - 150 - 45
                            self.timeAvailabilityTitleView.isHidden = true
                        }
                    })
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
    
    func cancelReservedOfferApi() {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(self.view)
            ServerClass.sharedInstance.getRequestWithUrlParameters([:], path: BASE_URL + PROJECT_URL.CANCEL_RESERVED_OFFER_API + "/\(ticketIdStr)", successBlock: { (json) in
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
                UIAlertController.showInfoAlertWithTitle("Alert", message: kUnexpectedErrorAlertString, buttonTitle: "Okay")
                hideAllProgressOnView(self.view)
            })
        }
        else{
            UIAlertController.showInfoAlertWithTitle("Alert", message: "Please Check internet connection", buttonTitle: "Okay")
        }
    }
}

//Mark:- Location Delegate Methods
extension EventBarCodeViewController : CLLocationManagerDelegate {
    func initializeTheLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locationManager.location?.coordinate
        currentLatitude = location!.latitude
        currentLongitude =  location!.longitude
        locationManager.stopUpdatingLocation()
        locationManager.delegate = nil
        if currentLatitude != 0 && currentLongitude != 0 {
            self.getEventDetailsApi()
        }
    }
}

extension EventBarCodeViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.timeAvailabilityList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceAvailabilityTableViewCell") as! ServiceAvailabilityTableViewCell
        cell.dayLbl.text = "Day : " + self.timeAvailabilityList[indexPath.row].day
        cell.startTimeLbl.text = "Start Time : " + self.timeAvailabilityList[indexPath.row].opening_time
        cell.endTimeLbl.text = "End Time : " + self.timeAvailabilityList[indexPath.row].closing_time
        cell.editBtn.isHidden = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
}
