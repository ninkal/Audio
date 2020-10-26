//
//  VenueViewController.swift
//  VanityPass
//
//  Created by Amit on 06/03/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit
import GoogleMaps
import MapKit
import CoreLocation

class VenueViewController: UIViewController, GMSMapViewDelegate {
    @IBOutlet weak var mapView : GMSMapView!
    @IBOutlet weak var customNavigationBar: CustomNavigationBar!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var distanceLbl : UILabel!
    var locationManager = CLLocationManager()
    var currentLatitude = CLLocationDegrees()
    var currentLongitude = CLLocationDegrees()
    var event : EventStruct!
    var eventName : String = ""
    var eventDistance : String = ""
    var eventLatitude : String = ""
    var eventLongitude :  String = ""
    var offer : OfferStruct!
    var bounds = GMSCoordinateBounds()
    var timer = Timer()

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        self.mapView.clear()
        self.initializeTheLocationManager()
    }
    
//    @objc func timerMethod() {
//        self.mapView.clear()
//        initializeTheLocationManager()
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(true)
//        timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(timerMethod), userInfo: nil, repeats: true)
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(true)
//        timer.invalidate()
//    }
    
    @IBAction func phoneBtnTap(_ sender: Any) {
        if let phoneCallURL = URL(string: "telprompt://\(event.phone1)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                if #available(iOS 10.0, *) {
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                }
                else {
                    application.openURL(phoneCallURL as URL)
                }
            }
        }
    }
    
    @IBAction func startNavigationBtnTap(_ sender: Any) {
//        if event != nil {
            let source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: currentLatitude, longitude: currentLongitude)))
            source.name = "Current Location"
            let destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: Double(eventLatitude)!, longitude: Double(eventLongitude)!)))
            destination.name = eventName
            MKMapItem.openMaps(with: [source, destination], launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
//        }
    }
}

//Mark:- Location Delegate Methods
extension VenueViewController : CLLocationManagerDelegate {
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
        if let location = locations.last{
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            marker.title = "You"
            marker.snippet = UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.USER_NAME) as? String
            let imageView = UIImageView.init()
            let imageUrlStr : String = UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.USER_IMAGE) as! String
            imageView.sd_setImage(with: URL(string: IMAGE_URL + "users/" + imageUrlStr), placeholderImage: #imageLiteral(resourceName: "userImage"))
            imageView.image = self.imageWithImage(image: imageView.image!, scaledToSize: CGSize(width: 50, height: 50))
            marker.icon = self.maskRoundedImage(image: imageView.image!, radius: 50/2)
            //            marker.iconView = imageView
            marker.appearAnimation = GMSMarkerAnimation.pop
            marker.map = self.mapView
            marker.infoWindowAnchor = CGPoint(x: 0.5, y: 0.2)
            self.bounds = self.bounds.includingCoordinate(marker.position)
            let update = GMSCameraUpdate.fit(self.bounds, withPadding: 60)
            self.mapView.animate(with: update)
        }
        // for venue location on map
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: Double(eventLatitude)!, longitude: Double(eventLongitude)!)
        marker.title = eventName
        marker.appearAnimation = GMSMarkerAnimation.pop
        marker.map = self.mapView
        marker.infoWindowAnchor = CGPoint(x: 0.5, y: 0.2)
        self.bounds = self.bounds.includingCoordinate(marker.position)
        self.distanceLbl.text =  eventDistance == "" ? "0 Km" : String(format: "%.2f", Double(eventDistance)!)  + " KM"
        let update = GMSCameraUpdate.fit(self.bounds, withPadding: 60)
        self.mapView.animate(with: update)
    }
}       
