//
//  EventDetailsViewController.swift
//  VanityPass
//
//  Created by Amit on 06/03/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit
import ImageSlideshow
import CoreLocation

struct OfferStruct {
    var frequency : String = ""
    var ticket_available : String = ""
    var name : String = ""
    var user_id : String = ""
    var updated_at : String = ""
    var created_at : String = ""
    var id : String = ""
    var closing_datetime : String = ""
    var thumbnail : String = ""
    var event_id : String = ""
    var description : String = ""
    var active : String = ""
    var expire_date : String = ""
    var is_premium : String = ""
}

class EventDetailsViewController: UIViewController, closeTransparent {
    @IBOutlet weak var scrollViewHeightConstranints: NSLayoutConstraint!
    @IBOutlet weak var eventViewHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var sunCheckBtn: UIButton!
    @IBOutlet weak var sunSaveBtn: UIButton!
    @IBOutlet weak var monCheckBtn: UIButton!
    @IBOutlet weak var monSaveBtn: UIButton!
    @IBOutlet weak var tueCheckBtn: UIButton!
    @IBOutlet weak var tueSaveBtn: UIButton!
    @IBOutlet weak var wedCheckBtn: UIButton!
    @IBOutlet weak var  wedSaveBtn: UIButton!
    @IBOutlet weak var thuCheckBtn: UIButton!
    @IBOutlet weak var thuSaveBtn: UIButton!
    @IBOutlet weak var friSaveBtn: UIButton!
    @IBOutlet weak var friCheckBtn: UIButton!
    @IBOutlet weak var satSaveBtn: UIButton!
    @IBOutlet weak var satCheckBtn: UIButton!
    let datePicker: UIDatePicker = UIDatePicker()
    var activeField: UITextField?
    var locationManager = CLLocationManager()
    var currentLatitude = CLLocationDegrees()
    var currentLongitude = CLLocationDegrees()
    
    @IBAction func sunCheckBtnClicked(_ sender: Any) {
        let myButton: UIButton? = sender as? UIButton
        let data1: Data? = (myButton?.currentImage)!.pngData()
        let data2: Data? = UIImage(named: "checkBoxPinkUnSelected")!.pngData()
        if data1 == data2 {
            sunCheckBtn.setImage(#imageLiteral(resourceName: "checkBoxPinkSelected"), for: .normal)
            sunSaveBtn.isHidden = false
        }
        else {
            sunCheckBtn.setImage(#imageLiteral(resourceName: "checkBoxPinkUnSelected"), for: .normal)
            sunSaveBtn.isHidden = true
        }
    }
    
    @IBAction func sunSaveBtnClicked(_ sender: Any) {
        saveApi(day: "Sunday", startDate: sunStartDate.text!, endDate: sunEndDate.text!,buttonCheck:self.sunCheckBtn, button: self.sunSaveBtn)
    }
    
    @IBAction func monCheckBtnClicked(_ sender: Any) {
        let myButton: UIButton? = sender as? UIButton
        let data1: Data? = (myButton?.currentImage)!.pngData()
        let data2: Data? = UIImage(named: "checkBoxPinkUnSelected")!.pngData()
        if data1 == data2 {
            monCheckBtn.setImage(#imageLiteral(resourceName: "checkBoxPinkSelected"), for: .normal)
            monSaveBtn.isHidden = false
        }
        else {
            monCheckBtn.setImage(#imageLiteral(resourceName: "checkBoxPinkUnSelected"), for: .normal)
            monSaveBtn.isHidden = true
        }
    }
    
    @IBAction func monSaveBtnClicked(_ sender: Any) {
        saveApi(day: "Monday",startDate: monStartDate.text!, endDate: monEndDate.text!,buttonCheck:self.monCheckBtn, button: self.monSaveBtn)
    }
    
    @IBAction func tueCheckBtnClicked(_ sender: Any) {
        let myButton: UIButton? = sender as? UIButton
        let data1: Data? = (myButton?.currentImage)!.pngData()
        let data2: Data? = UIImage(named: "checkBoxPinkUnSelected")!.pngData()
        if data1 == data2 {
            tueCheckBtn.setImage(#imageLiteral(resourceName: "checkBoxPinkSelected"), for: .normal)
            tueSaveBtn.isHidden = false
        }
        else {
            tueCheckBtn.setImage(#imageLiteral(resourceName: "checkBoxPinkUnSelected"), for: .normal)
            tueSaveBtn.isHidden = true
        }
    }
    
    @IBAction func tueSaveBtnClicked(_ sender: Any) {
        saveApi(day: "Tuesday",startDate: tueStartDate.text!, endDate: tueEndDate.text!,buttonCheck:self.tueCheckBtn, button: self.tueSaveBtn)
    }
    
    @IBAction func  wedCheckBtnClicked(_ sender: Any) {
        let myButton: UIButton? = sender as? UIButton
        let data1: Data? = (myButton?.currentImage)!.pngData()
        let data2: Data? = UIImage(named: "checkBoxPinkUnSelected")!.pngData()
        if data1 == data2 {
            wedCheckBtn.setImage(#imageLiteral(resourceName: "checkBoxPinkSelected"), for: .normal)
            wedSaveBtn.isHidden = false
        }
        else {
            wedCheckBtn.setImage(#imageLiteral(resourceName: "checkBoxPinkUnSelected"), for: .normal)
            wedSaveBtn.isHidden = true
        }
    }
    
    @IBAction func  wedSaveBtnClicked(_ sender: Any) {
        saveApi(day: "Wednesday",startDate: wedStartDate.text!, endDate: wedEndDate.text!,buttonCheck:self.wedCheckBtn, button: self.wedSaveBtn)
    }
    
    @IBAction func thuCheckBtnClicked(_ sender: Any) {
        let myButton: UIButton? = sender as? UIButton
        let data1: Data? = (myButton?.currentImage)!.pngData()
        let data2: Data? = UIImage(named: "checkBoxPinkUnSelected")!.pngData()
        if data1 == data2 {
            thuCheckBtn.setImage(#imageLiteral(resourceName: "checkBoxPinkSelected"), for: .normal)
            thuSaveBtn.isHidden = false
        }
        else {
            thuCheckBtn.setImage(#imageLiteral(resourceName: "checkBoxPinkUnSelected"), for: .normal)
            thuSaveBtn.isHidden = true
        }
    }
    
    @IBAction func thuSaveBtnClicked(_ sender: Any) {
        saveApi(day: "Thursday",startDate: thuStartDate.text!, endDate: thuEndDate.text!,buttonCheck:self.thuCheckBtn, button: self.thuSaveBtn)
    }
    
    @IBAction func friCheckBtnClicked(_ sender: Any) {
        let myButton: UIButton? = sender as? UIButton
        let data1: Data? = (myButton?.currentImage)!.pngData()
        let data2: Data? = UIImage(named: "checkBoxPinkUnSelected")!.pngData()
        if data1 == data2 {
            friCheckBtn.setImage(#imageLiteral(resourceName: "checkBoxPinkSelected"), for: .normal)
            friSaveBtn.isHidden = false
        }
        else {
            friCheckBtn.setImage(#imageLiteral(resourceName: "checkBoxPinkUnSelected"), for: .normal)
            friSaveBtn.isHidden = true
        }
    }
    
    @IBAction func friSaveBtnClicked(_ sender: Any) {
        saveApi(day: "Friday",startDate: friStartDate.text!, endDate: friEndDate.text!,buttonCheck:self.friCheckBtn, button: self.friSaveBtn)
    }
    
    @IBAction func satCheckBtnClicked(_ sender: Any) {
        let myButton: UIButton? = sender as? UIButton
        let data1: Data? = (myButton?.currentImage)!.pngData()
        let data2: Data? = UIImage(named: "checkBoxPinkUnSelected")!.pngData()
        if data1 == data2 {
            satCheckBtn.setImage(#imageLiteral(resourceName: "checkBoxPinkSelected"), for: .normal)
            satSaveBtn.isHidden = false
        }
        else {
            satCheckBtn.setImage(#imageLiteral(resourceName: "checkBoxPinkUnSelected"), for: .normal)
            satSaveBtn.isHidden = true
        }
    }
    
    @IBAction func satSaveBtnClicked(_ sender: Any) {
        saveApi(day: "Saturday",startDate: satStartDate.text!, endDate: satEndDate.text!,buttonCheck:self.satCheckBtn, button: self.satSaveBtn)
    }
    
    @IBAction func crossBtnClicked(_ sender: Any) {
        self.timeAvailabilityView.isHidden = true
    }
    
    //....................
    @IBOutlet weak var customNavigationBar: CustomNavigationBar!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var listOfOfferLbl: UILabel!
    @IBOutlet weak var venueNameLbl: UILabel!
    @IBOutlet weak var venueDescriptionTextView: UITextView!
    @IBOutlet weak var eventTableView: UITableView!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var slideShow:ImageSlideshow!
    var offerList : [OfferStruct] = []
    var event : EventStruct!
    var offerIdStr : String = ""
    
    @IBOutlet weak var addOfferViewHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var offerListTableView: UITableView!
    @IBOutlet weak var timeAvailabilityView: UIView!
    @IBOutlet weak var sunStartDate: UITextField!
    @IBOutlet weak var sunEndDate: UITextField!
    @IBOutlet weak var monStartDate: UITextField!
    @IBOutlet weak var monEndDate: UITextField!
    @IBOutlet weak var tueStartDate: UITextField!
    @IBOutlet weak var tueEndDate: UITextField!
    @IBOutlet weak var wedStartDate: UITextField!
    @IBOutlet weak var  wedEndDate: UITextField!
    @IBOutlet weak var thuStartDate: UITextField!
    @IBOutlet weak var thuEndDate: UITextField!
    @IBOutlet weak var friStartDate: UITextField!
    @IBOutlet weak var friEndDate: UITextField!
    @IBOutlet weak var satStartDate: UITextField!
    @IBOutlet weak var satEndDate: UITextField!
    
    func completeOffer(offerId : String) {
        if offerId != "" {
            //            self.dayTextField.text = ""
            //            self.startTimeTextField.text = ""
            //            self.endTimeTextField.text = ""
            self.timeAvailabilityView.isHidden = false
            offerIdStr = offerId
        }
        self.getOfferListApi()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        segmentedControl.selectedSegmentIndex = 0
        self.timeAvailabilityView.isHidden = true
        if UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.USER_TYPE) as! String == "model" {
            editBtn.isHidden = true
            segmentedControl.isHidden = false
            self.addOfferViewHeightConstraints.constant = 0
            locationManager.delegate = self
            initializeTheLocationManager()
            self.customNavigationBar.titleLabel.text = "Venue Details"
        }
        else {
            editBtn.isHidden = false
            segmentedControl.isHidden = true
            self.addOfferViewHeightConstraints.constant = 45
            self.eventViewHeightConstraints.constant = 0
            customNavigationBar.titleLabel.text = event.name
            self.getEventDetailsApi()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.eventTableView.tableFooterView = UIView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("memory full")
    }
    
    func saveApi(day: String,startDate:String,endDate:String,buttonCheck:UIButton,button:UIButton) {
        if (startDate.isEmpty) {
            showInvalidInputAlert("Start Date")
        }
        else if (endDate.isEmpty) {
            showInvalidInputAlert("End Date")
        }
        else {
            if Reachability.isConnectedToNetwork() {
                showProgressOnView(self.view)
                let param1 = ["event_id":event.id,
                              "offer_id":offerIdStr,
                              "day": day,
                              "opening_time":startDate,
                              "closing_time":endDate
                ]
                print(param1)
                ServerClass.sharedInstance.postRequestWithUrlParameters(param1, path: BASE_URL + PROJECT_URL.ADD_OFFER_TIME_AVAILABILISTY_API, successBlock: { (json) in
                    print(json)
                    hideAllProgressOnView(self.view)
                    let success = json["success"].stringValue
                    if success  == "true"  {
                        UIAlertController.showInfoAlertWithTitle("Message", message: json["message"].stringValue, buttonTitle: "Okay")
                        
                        
                        
                        //                        let alert = UIAlertController(title: "Message", message: json["message"].stringValue + "Do You Want Add Another Offer Time Availability", preferredStyle: .alert)
                        //                        let yesAction = UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                        //                            self.timeAvailabilityView.isHidden = false
                        //                            self.dayTextField.text = ""
                        //                            self.startTimeTextField.text = ""
                        //                            self.endTimeTextField.text = ""
                        //                        })
                        //
                        //                        let noAction = UIAlertAction(title: "No", style: .cancel, handler: { (action) in
                        //                            self.timeAvailabilityView.isHidden = true
                        //                        })
                        //                        alert.addAction(noAction)
                        //                        alert.addAction(yesAction)
                        //                        DispatchQueue.main.async {
                        //                            self.present(alert, animated: true, completion: nil)
                        //                        }
                      buttonCheck.isUserInteractionEnabled = false
                        button.isHidden = true
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
    
    func getEventDetailsApi() {
        if UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.USER_TYPE) as! String == "model" {
            let param1 = ["id":event.id,
                          "latitude": "\(currentLatitude)",
                        "longitude": "\(currentLongitude)"
//                "latitude":"28.53551610",
//                "longitude":"77.39102650",
            ]
            print(param1)
            if Reachability.isConnectedToNetwork() {
                showProgressOnView(self.view)
                ServerClass.sharedInstance.postRequestWithUrlParameters(param1, path: BASE_URL + PROJECT_URL.GET_MODEL_EVENT_DETAILS, successBlock: { (json) in
                    print(json)
                    hideAllProgressOnView(self.view)
                    let success = json["success"].stringValue
                    if success  == "true"  {
                        self.event.galleries.removeAll()
                        for i in 0..<json["data"]["galleries"].count {
                            self.event.galleries.append(IMAGE_URL + "events/" + json["data"]["galleries"][i].stringValue)
                        }
                        
                        self.slideShow.slideshowInterval = 5.0
                        self.slideShow.pageIndicatorPosition = .init(horizontal: .center, vertical: .customBottom(padding: 5))
                        self.slideShow.pageIndicator?.view.tintColor = UIColor.black
                        self.slideShow.contentScaleMode = UIView.ContentMode.scaleAspectFill
                        
                        let pageControl = UIPageControl()
                        pageControl.currentPageIndicatorTintColor = UIColor.lightGray
                        pageControl.pageIndicatorTintColor = UIColor.black
                        self.slideShow.pageIndicator = pageControl
                        self.slideShow.activityIndicator = DefaultActivityIndicator()
                        self.slideShow.currentPageChanged = { page in
                            print("current page:", page)
                        }
                        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTap))
                        self.slideShow.addGestureRecognizer(recognizer)
                        
                        var arr = [AlamofireSource]()
                        for image in self.event.galleries {
                            arr.append(AlamofireSource(urlString: image.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!)
                        }
                        self.slideShow.activityIndicator = DefaultActivityIndicator(style: .gray, color: nil)
                        self.slideShow.setImageInputs(arr)
                        
                        self.event.name = json["data"]["name"].stringValue
                        self.event.organiser_logo = json["data"]["organiser_logo"].stringValue
                        self.event.description = json["data"]["description"].stringValue
                        self.venueNameLbl.text = self.event.name
                        self.venueDescriptionTextView.text = self.event.description
                        self.getOfferListApi()
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
        else {
            if Reachability.isConnectedToNetwork() {
                showProgressOnView(self.view)
                ServerClass.sharedInstance.getRequestWithUrlParameters([:], path: BASE_URL + PROJECT_URL.GET_PARTNER_EVENT_DETAILS + "/\(event.id)", successBlock: { (json) in
                    print(json)
                    hideAllProgressOnView(self.view)
                    let success = json["success"].stringValue
                    if success  == "true"  {
                        self.event.galleries.removeAll()
                        for i in 0..<json["data"]["galleries"].count {
                            self.event.galleries.append(IMAGE_URL + "events/" + json["data"]["galleries"][i].stringValue)
                        }
                        
                        self.slideShow.slideshowInterval = 5.0
                        self.slideShow.pageIndicatorPosition = .init(horizontal: .center, vertical: .customBottom(padding: 5))
                        self.slideShow.pageIndicator?.view.tintColor = UIColor.black
                        self.slideShow.contentScaleMode = UIView.ContentMode.scaleAspectFill
                        
                        let pageControl = UIPageControl()
                        pageControl.currentPageIndicatorTintColor = UIColor.lightGray
                        pageControl.pageIndicatorTintColor = UIColor.black
                        self.slideShow.pageIndicator = pageControl
                        self.slideShow.activityIndicator = DefaultActivityIndicator()                
                        self.slideShow.currentPageChanged = { page in
                            print("current page:", page)
                        }
                        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTap))
                        self.slideShow.addGestureRecognizer(recognizer)
                        
                        var arr = [AlamofireSource]()
                        for image in self.event.galleries {
                            arr.append(AlamofireSource(urlString: image.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!)
                        }
                        self.slideShow.activityIndicator = DefaultActivityIndicator(style: .gray, color: nil)
                        self.slideShow.setImageInputs(arr)
                        
                        self.event.name = json["data"]["name"].stringValue
                        self.event.description = json["data"]["description"].stringValue
                        self.venueNameLbl.text = self.event.name
                        self.venueDescriptionTextView.text = self.event.description
                        self.customNavigationBar.titleLabel.text = self.event.name
                        self.getOfferListApi()
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
    
    @IBAction func editBtnTap(_ sender: Any) {
        let viewController = UIStoryboard.addEventViewController()
        viewController.event = event
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func segmentClicked(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex {
        case 0: break
        case 1: let viewController = UIStoryboard.venueViewController()
        viewController.event = event
        viewController.eventName = event.name
        viewController.eventDistance = event.distance
        viewController.eventLatitude = event.latitude
        viewController.eventLongitude = event.longitude
        self.navigationController?.pushViewController(viewController, animated: true); break
        default:break;
        }
    }
    
    @IBAction func addOfferBtnTap(_ sender: Any) {
        let modalViewController = TransParent1ViewController()
        modalViewController.modalPresentationStyle = .overFullScreen // .overCurrentContext
        modalViewController.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
        modalViewController.event = self.event
        modalViewController.delegate = self
        self.present(modalViewController, animated: true)
    }
    
    func getOfferListApi() {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(self.view)
            if UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.USER_TYPE) as! String == "model" {
                let param1 = ["event_id" : event.id,"page":"1", "limit":"10","timezone" :event.timezone]
                print(param1)
                ServerClass.sharedInstance.postRequestWithUrlParameters(param1, path: BASE_URL + PROJECT_URL.OFFER_LIST_API, successBlock: { (json) in
                    print(json)
                    hideAllProgressOnView(self.view)
                    self.offerList.removeAll()
                    let success = json["success"].stringValue
                    if success  == "true"  {
                        for i in 0..<json["data"].count {
                            self.offerList.append(OfferStruct.init(frequency: json["data"][i]["frequency"].stringValue, ticket_available: json["data"][i]["ticket_available"].stringValue, name: json["data"][i]["name"].stringValue, user_id: json["data"][i]["user_id"].stringValue, updated_at: json["data"][i]["updated_at"].stringValue, created_at: json["data"][i]["created_at"].stringValue, id: json["data"][i]["id"].stringValue, closing_datetime: json["data"][i]["closing_datetime"].stringValue, thumbnail: json["data"][i]["thumbnail"].stringValue, event_id: json["data"][i]["event_id"].stringValue, description: json["data"][i]["description"].stringValue, active: json["data"][i]["active"].stringValue, expire_date : json["data"][i]["offer_expire_date"].stringValue, is_premium: json["data"][i]["is_premium"].stringValue))
                        }
                        self.offerList.sort { $0.ticket_available > $1.ticket_available }

                        UIView.animate(withDuration: 0, delay: 0, options: .curveEaseInOut, animations: {() -> Void in
                            self.eventTableView.isScrollEnabled = false
                            self.eventTableView.reloadData()
                            self.eventTableView.layoutIfNeeded()
                        }, completion: {(_ finished: Bool) -> Void in
                            var tableFrame = self.eventTableView.frame
                            tableFrame.size.height = self.eventTableView.contentSize.height
                            tableFrame.size.width = self.eventTableView.contentSize.width
                            self.scrollViewHeightConstranints.constant = 635 - 100 + tableFrame.size.height
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
            else {
                ServerClass.sharedInstance.getRequestWithUrlParameters([:], path: BASE_URL + PROJECT_URL.PARTNER_EVENT_OFFER_LIST_API + "/" + event.id, successBlock: { (json) in
                    print(json)
                    hideAllProgressOnView(self.view)
                    self.offerList.removeAll()
                    let success = json["success"].stringValue
                    if success  == "true"  {
                        for i in 0..<json["data"].count {
                            self.offerList.append(OfferStruct.init(frequency: json["data"][i]["frequency"].stringValue, ticket_available: json["data"][i]["ticket_available"].stringValue, name: json["data"][i]["name"].stringValue, user_id: json["data"][i]["user_id"].stringValue, updated_at: json["data"][i]["updated_at"].stringValue, created_at: json["data"][i]["created_at"].stringValue, id: json["data"][i]["id"].stringValue, closing_datetime: json["data"][i]["closing_datetime"].stringValue, thumbnail: json["data"][i]["thumbnail"].stringValue, event_id: json["data"][i]["event_id"].stringValue, description: json["data"][i]["description"].stringValue, active: json["data"][i]["active"].stringValue, expire_date: String(json["data"][i]["expire_date"].stringValue.prefix(10)), is_premium: json["data"][i]["is_premium"].stringValue))
                        }
                        self.offerList.sort { $0.ticket_available > $1.ticket_available }

                        UIView.animate(withDuration: 0, delay: 0, options: .curveEaseInOut, animations: {() -> Void in
                            self.eventTableView.isScrollEnabled = false
                            self.eventTableView.reloadData()
                            self.eventTableView.layoutIfNeeded()
                        }, completion: {(_ finished: Bool) -> Void in
                            var tableFrame = self.eventTableView.frame
                            tableFrame.size.height = self.eventTableView.contentSize.height
                            tableFrame.size.width = self.eventTableView.contentSize.width
                            self.eventViewHeightConstraints.constant = 0
                            self.scrollViewHeightConstranints.constant = 635 - 180 - 100 + tableFrame.size.height
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
        }
        else{
            UIAlertController.showInfoAlertWithTitle("Alert", message: "Please Check internet connection", buttonTitle: "Okay")
        }
    }
    
    @objc func didTap() {
        let fullScreenController = slideShow.presentFullScreenController(from: self)
        fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
    }
}

extension EventDetailsViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.offerList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventsTableViewCell") as! EventsTableViewCell
        cell.imgView.sd_setImage(with: URL(string : IMAGE_URL + "events/" + self.offerList[indexPath.item].thumbnail), placeholderImage: #imageLiteral(resourceName: "placeholder"))
        cell.nameLbl.text = self.offerList[indexPath.row].name
        cell.descriptionLbl.text = self.offerList[indexPath.row].description
        cell.statusLbl.text =  Int(self.offerList[indexPath.item].ticket_available)! > 0 ? "Available" : "Sold Out"
        cell.statusLbl.textColor = Int(self.offerList[indexPath.item].ticket_available)! > 0 ? UIColor.init(red: 0/255, green: 145/255, blue: 0/255, alpha: 1.0)  : UIColor.red
        cell.editBtn.isHidden = true

//        if UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.USER_TYPE) as! String == "model" {
//            cell.statusLbl.text =  Int(self.offerList[indexPath.item].ticket_available)! > 0 ? "Available" : "Sold Out"
//            cell.statusLbl.textColor = Int(self.offerList[indexPath.item].ticket_available)! > 0 ? UIColor.init(red: 0/255, green: 145/255, blue: 0/255, alpha: 1.0)  : UIColor.red
//            //            cell.editBtn.setTitle("Reserve", for: .normal)
//            //            cell.editBtn.addTarget(self, action: #selector(reserveBtnTap), for: .touchUpInside)
//            //            cell.editBtn.tag = indexPath.row
//            cell.editBtn.isHidden = true
//        }
//        else {
//            cell.statusLbl.text =  ""
//            cell.editBtn.setTitle("Edit", for: .normal)
//            cell.editBtn.isHidden = true
////            cell.editBtn.addTarget(self, action: #selector(editBtnTap), for: .touchUpInside)
////            cell.editBtn.tag = indexPath.row
//        }
        
        if self.offerList[indexPath.row].is_premium == "1" {
            cell.starImgView.isHidden = false
        }
        else {
            cell.starImgView.isHidden = true
        }
        return cell
    }
    
//    @objc func reserveBtnTap(sender: UIButton) {
//
//    }
    
//    @objc func editBtnTap(sender: UIButton) {
//        let modalViewController = TransParent1ViewController()
//        modalViewController.modalPresentationStyle = .overFullScreen // .overCurrentContext
//        modalViewController.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
//        modalViewController.event = self.event
//        modalViewController.offer = self.offerList[sender.tag]
//        modalViewController.delegate = self
//        self.present(modalViewController, animated: true)
//    }
//    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = UIStoryboard.offerDetailsViewController()
        viewController.offer = self.offerList[indexPath.row]
        viewController.event = self.event
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension EventDetailsViewController : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
        self.createDatePicker()
    }
    
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
        datePicker.addTarget(self, action: #selector(EventDetailsViewController.datePickerValueChanged(_:)), for: .valueChanged)
        // Add DataPicker to the view
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.backgroundColor = UIColor.black
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(EventDetailsViewController.donePicker))
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

//Mark:- Location Delegate Methods
extension EventDetailsViewController : CLLocationManagerDelegate {
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
