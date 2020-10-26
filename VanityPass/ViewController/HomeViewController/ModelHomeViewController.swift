//
//  MapAndListViewController.swift
//  VanityPass
//
//  Created by chawtech solutions on 3/5/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

struct EventStruct {
    var id: String = ""
    var organiser_name: String = ""
    var organiser_logo: String = ""
    var name : String = ""
    var description : String = ""
    var user_id: String = ""
    var address : String = ""
    var latitude : String = ""
    var longitude : String = ""
    var phone1 : String = ""
    var phone2 : String = ""
    var city : String = ""
    var pincode : String = ""
    var state : String = ""
    var country : String = ""
    var opening_time : String = ""
    var closing_time: String = ""
    var thumbnail: String = ""
    var galleries: [String] = []
    var active: String = ""
    var email: String = ""
    var first_name: String = ""
    var last_name: String = ""
    var ticket_available: String = ""
    var distance: String = ""
    var timezone : String = ""
}

class ModelHomeViewController: UIViewController, GMSMapViewDelegate {
    @IBOutlet weak var sigmentedControl: UISegmentedControl!
    @IBOutlet weak var mapView : GMSMapView!
    @IBOutlet weak var listView: UIView!
    @IBOutlet weak var listTableView: UITableView!
    var locationManager = CLLocationManager()
    var currentLatitude = CLLocationDegrees()
    var currentLongitude = CLLocationDegrees()
    var eventList : [EventStruct] = []
    var markers = [GMSMarker]()
    var bounds = GMSCoordinateBounds()
    var timeZoneStr = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.clear()
        mapView.delegate = self
        locationManager.delegate = self
        showProgressOnView(self.view)
        self.listTableView.tableFooterView = UIView()
        initializeTheLocationManager()
    }
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true) 
//        self.mapView.clear()
//        initializeTheLocationManager()
//        timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(timerMethod), userInfo: nil, repeats: true)
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(true)
//        timer.invalidate()
//    }
//    
//    @objc func timerMethod() {
//        self.mapView.clear()
//        initializeTheLocationManager()
//    }
    
    @IBAction func refreshBtnTap(_ sender: Any) {
        self.getEventListApi()
    }
    
    @IBAction func segmentClicked(_ sender: Any) {
        switch sigmentedControl.selectedSegmentIndex {
        case 0: self.view.bringSubviewToFront(self.listView); break
        case 1: self.view.bringSubviewToFront(self.mapView); break
        default:break;
        }
    }
    
    func updateLocationApi() {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(self.view)
//            let param1:[String:String] = ["latitude":"28.53551610",
//                                          "longitude":"77.39102650"
//                                          ]
                        let param1:[String:String] = ["latitude":"\(currentLatitude)",
                            "longitude":"\(currentLongitude)"]
            print(param1)
            ServerClass.sharedInstance.postRequestWithUrlParameters(param1, path: BASE_URL + PROJECT_URL.UPDATE_LOCATION_API, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(self.view)
                let success = json["success"].stringValue
                if success  == "true"  {
                }
                else {
//                    UIAlertController.showInfoAlertWithTitle("Message", message: json["message"].stringValue, buttonTitle: "Okay")
                }
            }, errorBlock: { (NSError) in
//                UIAlertController.showInfoAlertWithTitle("Alert", message: kUnexpectedErrorAlertString, buttonTitle: "Okay")
                hideAllProgressOnView(self.view)
            })
        }
        else{
            hideAllProgressOnView(self.view)
//            UIAlertController.showInfoAlertWithTitle("Alert", message: "Please Check internet connection", buttonTitle: "Okay")
        }
    }
    
    func getEventListApi() {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(self.view)
//            self.timeZoneStr = TimeZone.current.identifier
            let param1:[String:String] = [
                "latitude":"\(currentLatitude)",
                "longitude":"\(currentLongitude)",
                "radius":"50",
                "unit_type":"mi",
                "timezone" :self.timeZoneStr
]
            print(param1)
            ServerClass.sharedInstance.postRequestWithUrlParameters(param1, path: BASE_URL + PROJECT_URL.EVENT_LIST_API, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(self.view)
                let success = json["success"].stringValue
                if success  == "true"  {
                    sideMenuViewController.hideLeftViewAnimated()
                    self.eventList.removeAll()
//                    self.mapView.removeAnnotations(self.mapView!.annotations)
                    for i in 0..<json["data"].count {
                        var galleryList : [String] = []
                        for j in 0..<json["data"][i]["galleries"].count {
                            galleryList.append(IMAGE_URL + "events/" + json["data"][i]["galleries"][j].stringValue)
                        }
                        self.eventList.append(EventStruct.init(id: json["data"][i]["id"].stringValue, organiser_name: json["data"][i]["organiser_name"].stringValue, organiser_logo: json["data"][i]["organiser_logo"].stringValue, name: json["data"][i]["name"].stringValue, description: json["data"][i]["description"].stringValue, user_id: json["data"][i]["user_id"].stringValue, address: json["data"][i]["address"].stringValue, latitude: json["data"][i]["latitude"].stringValue, longitude: json["data"][i]["longitude"].stringValue, phone1: json["data"][i]["phone1"].stringValue, phone2: json["data"][i]["phone2"].stringValue, city: json["data"][i]["city"].stringValue, pincode: json["data"][i]["pincode"].stringValue, state: json["data"][i]["state"].stringValue, country: json["data"][i]["country"].stringValue, opening_time: String(json["data"][i]["opening_time"].stringValue.prefix(5)), closing_time: String(json["data"][i]["closing_time"].stringValue.prefix(5)), thumbnail: json["data"][i]["thumbnail"].stringValue, galleries: galleryList, active: json["data"][i]["active"].stringValue, email: json["data"][i]["email"].stringValue, first_name: json["data"][i]["first_name"].stringValue, last_name: json["data"][i]["last_name"].stringValue, ticket_available: json["data"][i]["ticket_available"].stringValue, distance: String(format: "%.2f", Double(json["data"][i]["distance"].stringValue)!), timezone: json["data"][i]["timezone"].stringValue))
                    }
                    self.drawMarker()
                    self.eventList.sort { $0.ticket_available > $1.ticket_available }
                    self.listTableView.reloadData()
                    self.updateLocationApi()
                }
                else {
                    UIAlertController.showInfoAlertWithTitle("Message", message: json["message"].stringValue, buttonTitle: "Okay")
                    self.eventList.removeAll()
                    self.listTableView.reloadData()
                }
            }, errorBlock: { (NSError) in
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

extension ModelHomeViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.eventList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell") as! HomeTableViewCell
        cell.logoImageView.sd_setImage(with: URL(string : IMAGE_URL + "events/" + self.eventList[indexPath.row].organiser_logo), placeholderImage: #imageLiteral(resourceName: "placeholder"))
        cell.nameLbl.text = self.eventList[indexPath.row].name
        cell.statusLbl.text = Int(self.eventList[indexPath.row].ticket_available)! > 0 ? "Available" : "Sold Out"
        cell.statusLbl.textColor = Int(self.eventList[indexPath.row].ticket_available)! > 0 ? UIColor.init(red: 0/255, green: 145/255, blue: 0/255, alpha: 1.0) : UIColor.red
        cell.distanceLbl.text = self.eventList[indexPath.row].distance == "" ? "0 Km" : self.eventList[indexPath.row].distance + " KM"
        cell.addressLbl.text = self.eventList[indexPath.row].address
        
        cell.moreInfoBtn.tag = indexPath.row
        cell.moreInfoBtn.addTarget(self, action: #selector(moreInfoBtnTap), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = UIStoryboard.eventDetailsViewController()
        viewController.event = self.eventList[indexPath.row]
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 128  
    }
    
    @objc func moreInfoBtnTap(sender: UIButton) {
        let viewController = UIStoryboard.eventDetailsViewController()
        viewController.event = self.eventList[sender.tag]
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

//Mark:- Location Delegate Methods
extension ModelHomeViewController : CLLocationManagerDelegate {
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
            self.getTimeZoneApi()
//            self.getEventListApi()
        }
        
        if let location = locations.last{
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            marker.title = "You"
            marker.snippet = UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.USER_NAME) as? String
           print(location.coordinate)
            let imageUrlStr : String = UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.USER_IMAGE) as! String
            if let image : UIImage = UIImage.init(url: URL(string: IMAGE_URL + "users/" + imageUrlStr)) {
                let circularImage : UIImage = self.imageWithImage(image: image, scaledToSize: CGSize(width: 50, height: 50))
                let croppedCircularImage : UIImage = self.maskRoundedImage(image: circularImage, radius: 50/2)
                marker.icon = croppedCircularImage
            }
            else {
                marker.icon = self.imageWithImage(image: #imageLiteral(resourceName: "userImage"), scaledToSize: CGSize(width: 50, height: 50))
            }
//            marker.iconView = imageView
            marker.appearAnimation = GMSMarkerAnimation.pop
            marker.map = self.mapView
            marker.infoWindowAnchor = CGPoint(x: 0.5, y: 0.2)
            self.bounds = self.bounds.includingCoordinate(marker.position)
        }
    }
    
    func getTimeZoneApi() {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(self.view)
            ServerClass.sharedInstance.getTimeZoneGoogleApi(path: "https://maps.googleapis.com/maps/api/timezone/json?location=\(self.currentLatitude),\(self.currentLongitude)&timestamp=\(NSDate().timeIntervalSince1970)&key=\(GOOGLE_API_KEY)", successBlock: { (json) in
                print(json)
                hideAllProgressOnView(self.view)
                let status = json["status"].stringValue
                if status  == "OK"  {
                    self.timeZoneStr = json["timeZoneId"].stringValue
                    self.getEventListApi()
                }
                else {
                    UIAlertController.showInfoAlertWithTitle("Message", message: json["message"].stringValue, buttonTitle: "Okay")
                    self.getEventListApi()
                }
            }, errorBlock: { (NSError) in
                UIAlertController.showInfoAlertWithTitle("Alert", message: kUnexpectedErrorAlertString, buttonTitle: "Okay")
                hideAllProgressOnView(self.view)
                self.getEventListApi()
            })
        }
        else{
            UIAlertController.showInfoAlertWithTitle("Alert", message: "Please Check internet connection", buttonTitle: "Okay")
        }
    }
}

extension UIImage {
    convenience init?(url: URL?) {
        guard let url = url else { return nil }
        do {
            let data = try Data(contentsOf: url)
            self.init(data: data)
        } catch {
            print("Cannot load image from url: \(url) with error: \(error)")
            return nil
        }
    }
}

extension ModelHomeViewController {
    func drawMarker(){
        DispatchQueue.main.async {
            for marker in self.markers {
                marker.map = nil
            }
//            self.mapView.clear()
            self.markers.removeAll()
            for i in 0..<self.eventList.count {
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: Double(self.eventList[i].latitude)!, longitude: Double(self.eventList[i].longitude)!)
                marker.title = self.eventList[i].name
                marker.appearAnimation = GMSMarkerAnimation.pop
                marker.map = self.mapView
                marker.infoWindowAnchor = CGPoint(x: 0.5, y: 0.2)
                self.markers.append(marker)
                self.bounds = self.bounds.includingCoordinate(marker.position)
//                self.mapView?.camera = GMSCameraPosition.cameraWithTarget(marker.position, zoom: 9.0)
            }
            let update = GMSCameraUpdate.fit(self.bounds, withPadding: 60)
            self.mapView.animate(with: update)
        }
    }
    
//    // MARK: - GMUMapViewDelegate
//    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
//        if let index = markers.index(of: marker) {
//            let viewController = UIStoryboard.eventDetailsViewController()
//            viewController.event = self.eventList[index]
//            self.navigationController?.pushViewController(viewController, animated: true)
//        }
//        return true
//    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        if let index = markers.firstIndex(of: marker) {
            let viewController = UIStoryboard.eventDetailsViewController()
            viewController.event = self.eventList[index]
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }   
}
