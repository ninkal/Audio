//
//  AddEventViewController.swift
//  VanityPass
//
//  Created by Demo on 14/03/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit
import DropDown
import YangMingShan
import GooglePlaces

class AddEventViewController: UIViewController {
    @IBOutlet weak var customNavigationBar: CustomNavigationBar!
    @IBOutlet weak var organizationNameTextField: UITextField!
    @IBOutlet weak var eventNameTextField: UITextField!
    @IBOutlet weak var eventAddressTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var alternatePhoneTextField: UITextField!
    @IBOutlet weak var doneBtn: UIButton!
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    let imagePicker = UIImagePickerController()

    var logoStr : String = ""
    let amountDropDown = DropDown()
    
    var imageList : [String] = []
    var street_address = ""
    var city = ""
    var state = ""
    var country = ""
    var zipCodeStr = ""
    var latitudeStr : String = ""
    var longitudeStr : String = ""
    var timer: Timer? = nil
    var searchResults = [String]()
    var event:EventStruct!
    var timeZoneStr : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        if event == nil {
            customNavigationBar.titleLabel.text = "Add Venue"
            logoImageView.isHidden = true
        }
        else {
            customNavigationBar.titleLabel.text = "Edit Venue"
            logoImageView.isHidden = false
        }
        self.updateEventDetails()
    }
    
    func updateEventDetails() {
        if event != nil {
            organizationNameTextField.text = event.organiser_name
            eventNameTextField.text = event.name
            eventAddressTextField.text = event.address
            descriptionTextView.text = event.description
            logoImageView.sd_setImage(with: URL.init(string: IMAGE_URL + "events/" + event.organiser_logo)!, placeholderImage: #imageLiteral(resourceName: "add_Plus"))
            phoneTextField.text = event.phone1
            alternatePhoneTextField.text = event.phone2
            self.latitudeStr  = event.latitude
            self.longitudeStr = event.longitude
            self.city = event.city
            self.state = event.state
            self.country = event.country
            self.zipCodeStr = event.pincode
            self.timeZoneStr = event.timezone
            self.logoStr = event.organiser_logo
            
            var eventListImageStr : [String] = []
            for event in event.galleries {
                eventListImageStr.append(event.components(separatedBy: "/").last!)
            }
            event.galleries.removeAll()
            event.galleries = eventListImageStr
            self.imageList = event.galleries
            self.imageCollectionView.reloadData()
        }
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
            self.amountDropDown
        ]
    }()
    
    @IBAction func uploadEventGalleryBtnTap(_ sender: Any) {
        let pickerViewController = YMSPhotoPickerViewController.init()
        pickerViewController.numberOfPhotoToSelect = 9999
        
        let customColor = UIColor.init(red: 213.0/255.0, green: 4.0/255.0, blue: 73.0/255.0, alpha: 1.0)
        let customCameraColor = UIColor.init(red: 213.0/255.0, green: 4.0/255.0, blue: 73.0/255.0, alpha: 1.0)
        
        pickerViewController.theme.titleLabelTextColor = UIColor.white
        pickerViewController.theme.navigationBarBackgroundColor = customColor
        pickerViewController.theme.tintColor = UIColor.white
        pickerViewController.theme.orderTintColor = customCameraColor
        pickerViewController.theme.cameraVeilColor = customCameraColor
        pickerViewController.theme.cameraIconColor = UIColor.white
        pickerViewController.theme.statusBarStyle = .lightContent
        
        self.yms_presentCustomAlbumPhotoView(pickerViewController, delegate: self)
    }
    
    @IBAction func uploadLogoBtnTap(_ sender: Any) {
//        let pickerViewController = YMSPhotoPickerViewController.init()
//        pickerViewController.yms_presentAlbumPhotoView(with: self)
//
//        let customColor = UIColor.init(red: 213.0/255.0, green: 4.0/255.0, blue: 73.0/255.0, alpha: 1.0)
//        let customCameraColor = UIColor.init(red: 213.0/255.0, green: 4.0/255.0, blue: 73.0/255.0, alpha: 1.0)
//
//        pickerViewController.theme.titleLabelTextColor = UIColor.white
//        pickerViewController.theme.navigationBarBackgroundColor = customColor
//        pickerViewController.theme.tintColor = UIColor.white
//        pickerViewController.theme.orderTintColor = customCameraColor
//        pickerViewController.theme.cameraVeilColor = customCameraColor
//        pickerViewController.theme.cameraIconColor = UIColor.white
//        pickerViewController.theme.statusBarStyle = .lightContent
//
//        self.yms_presentCustomAlbumPhotoView(pickerViewController, delegate: self)
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallary()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func uploadImageApi(image:UIImage, index: Int, type : String) {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(self.view)
            if type == "logo" {
                saveImageDocumentDirectory(usedImage: image, nameStr : "file.png")
                let imageToUploadURL = URL(fileURLWithPath: (getDirectoryPath() as NSString).appendingPathComponent("file.png"))
                ServerClass.sharedInstance.sendImageMultipartRequestToServerWithToken(apiUrlStr: BASE_URL + PROJECT_URL.UPLOAD_PARTNER_FILE_API, imageKeyName: "file", imageUrl: imageToUploadURL, successBlock: {(json) in
                    print(json)
                    hideAllProgressOnView(self.view)
                    let success = json["success"].stringValue
                    if success  == "true"  {
                        self.logoStr = json["data"]["filename"].stringValue
                        //                UIAlertController.showInfoAlertWithTitle("Message", message: json["message"].stringValue, buttonTitle: "Okay")
                    }
                    else {
                        UIAlertController.showInfoAlertWithTitle("Message", message: json["message"].stringValue, buttonTitle: "Okay")
                    }
                }, errorBlock: { (NSError) in
                    hideAllProgressOnView(self.view)
                    UIAlertController.showInfoAlertWithTitle("Alert", message: kUnexpectedErrorAlertString, buttonTitle: "Okay")
                })
            }
            else {
                saveImageDocumentDirectory(usedImage: image, nameStr : "file\(index).png")
                let imageToUploadURL = URL(fileURLWithPath: (getDirectoryPath() as NSString).appendingPathComponent("file\(index).png"))
                ServerClass.sharedInstance.sendImageMultipartRequestToServerWithToken(apiUrlStr: BASE_URL + PROJECT_URL.UPLOAD_PARTNER_FILE_API, imageKeyName: "file", imageUrl: imageToUploadURL, successBlock: {(json) in
                    print(json)
                    hideAllProgressOnView(self.view)
                    let success = json["success"].stringValue
                    if success  == "true"  {
                        self.imageList.append(json["data"]["filename"].stringValue)
                        self.imageCollectionView.reloadData()
                        //                UIAlertController.showInfoAlertWithTitle("Message", message: json["message"].stringValue, buttonTitle: "Okay")
                    }
                    else {
                        UIAlertController.showInfoAlertWithTitle("Message", message: json["message"].stringValue, buttonTitle: "Okay")
                    }
                }, errorBlock: { (NSError) in
                    hideAllProgressOnView(self.view)
                    UIAlertController.showInfoAlertWithTitle("Alert", message: kUnexpectedErrorAlertString, buttonTitle: "Okay")
                })
            }
        }
        else {
            hideAllProgressOnView(self.view)
            UIAlertController.showInfoAlertWithTitle("Alert", message: "Please Check internet connection", buttonTitle: "Okay")
        }
    }
    
    @IBAction func doneBtnTap(_ sender: Any) {
        if (organizationNameTextField.text?.isEmpty)! {
            showInvalidInputAlert(organizationNameTextField.placeholder!)
        }
        else if (eventNameTextField.text?.isEmpty)! {
            showInvalidInputAlert(eventNameTextField.placeholder!)
        }
        else if (eventAddressTextField.text?.isEmpty)! {
            showInvalidInputAlert(eventAddressTextField.placeholder!)
        }
        else if (descriptionTextView.text?.isEmpty)! {
            showInvalidInputAlert("Description")
        }
        else if logoImageView.image == #imageLiteral(resourceName: "add_Plus") {
            showInvalidInputAlert("Organiser Logo")
        }
        else if (phoneTextField.text?.isEmpty)! {
            showInvalidInputAlert(phoneTextField.placeholder!)
        }
        else if self.latitudeStr == "" || self.longitudeStr == "" {
            UIAlertController.showInfoAlertWithTitle("Error", message: "Please enter valid address", buttonTitle: "Okay")
        }
        else {
            if Reachability.isConnectedToNetwork() {
                showProgressOnView(self.view)
                var param1:[String:Any] = [
                    "organiser_name": organizationNameTextField.text!,
                    "name": eventNameTextField.text!,
                    "address": eventAddressTextField.text!,
                    "description": descriptionTextView.text!,
                    "organiser_logo" : logoStr,
                    "thumbnail" : "",
                    "city":self.city,
                    "state":self.state,
                    "country":self.country,
                    "latitude":self.latitudeStr,
                    "longitude":self.longitudeStr,
                    "phone1":phoneTextField.text!,
                    "phone2":alternatePhoneTextField.text!,
                    "galleries":self.imageList,
                    "pincode":self.zipCodeStr,
                    "timezone":self.timeZoneStr
                ]
                if event == nil {
                    print(param1)
                    ServerClass.sharedInstance.postRequestWithUrlParameters(param1, path: BASE_URL + PROJECT_URL.ADD_EVENT_API, successBlock: { (json) in
                        print(json)
                        hideAllProgressOnView(self.view)
                        let success = json["success"].stringValue
                        if success  == "true"  {
                            self.navigationController?.popViewController(animated: true)
                            UIAlertController.showInfoAlertWithTitle("Success", message: json["message"].stringValue +
                                " Please add offers by clicking on created event.", buttonTitle: "Okay")
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
                    param1.updateValue(event.id, forKey: "id")
                    print(param1)
                    ServerClass.sharedInstance.postRequestWithUrlParameters(param1, path: BASE_URL + PROJECT_URL.EDIT_EVENT_API, successBlock: { (json) in
                        print(json)
                        hideAllProgressOnView(self.view)
                        let success = json["success"].stringValue
                        if success  == "true"  {
                            self.navigationController?.popViewController(animated: true)
                            UIAlertController.showInfoAlertWithTitle("Success", message: json["message"].stringValue, buttonTitle: "Okay")
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
}

extension AddEventViewController : UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == descriptionTextView {
            if textView.text == "Description" {
                descriptionTextView.text = ""
                descriptionTextView.textColor = UIColor.black
            }
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == descriptionTextView {
            if textView.text == "" {
                descriptionTextView.text = "Description"
                descriptionTextView.textColor = UIColor.darkGray
            }
        }
    }
}

extension AddEventViewController : YMSPhotoPickerViewControllerDelegate {
    func photoPickerViewControllerDidReceivePhotoAlbumAccessDenied(_ picker: YMSPhotoPickerViewController!) {
        let alertController = UIAlertController(title: "Allow photo album access?", message: "Need your permission to access photo albums", preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (action) in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        }
        alertController.addAction(dismissAction)
        alertController.addAction(settingsAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func photoPickerViewControllerDidReceiveCameraAccessDenied(_ picker: YMSPhotoPickerViewController!) {
        let alertController = UIAlertController(title: "Allow camera album access?", message: "Need your permission to take a photo", preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (action) in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        }
        alertController.addAction(dismissAction)
        alertController.addAction(settingsAction)
        
        // The access denied of camera is always happened on picker, present alert on it to follow the view hierarchy
        picker.present(alertController, animated: true, completion: nil)
    }
    
//    func photoPickerViewController(_ picker: YMSPhotoPickerViewController!, didFinishPicking image: UIImage!) {
//        picker.dismiss(animated: true) {
//            self.logoImageView.isHidden = false
//            self.logoImageView.image = image
//            self.uploadImageApi(image: image!, index : 0, type: "logo")
//        }
//    }
    
    func photoPickerViewController(_ picker: YMSPhotoPickerViewController!, didFinishPickingImages photoAssets: [PHAsset]!) {
        // Remember images you get here is PHAsset array, you need to implement PHImageManager to get UIImage data by yourself
        picker.dismiss(animated: true) {
//            let manager = PHImageManager.default()
//            let option = PHImageRequestOptions()
//            option.isSynchronous = true
            //            self.polaroidsList.removeAll()
            for i in 0..<photoAssets.count {
                let asset: PHAsset = photoAssets[i]
                var img: UIImage?
                let manager = PHImageManager.default()
                let options = PHImageRequestOptions()
                options.version = .original
                options.isSynchronous = true
                manager.requestImageData(for: asset, options: options) { data, _, _, _ in
                    if let data = data {
                        img = UIImage(data: data)
                        self.uploadImageApi(image: img!, index : i, type: "gallery")
                    }
                }
//                manager.requestImage(for: asset, targetSize: CGSize(width: 100.0, height: 100.0), contentMode: .aspectFit, options: option, resultHandler: {(image, info)->Void in
//                    self.uploadImageApi(image: image!, index : i, type: "gallery")
//                })
            }
            self.imageCollectionView.reloadData()
        }
    }
}

extension AddEventViewController : UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ServiceImageCollectionViewCell", for: indexPath as IndexPath) as! ServiceImageCollectionViewCell
        cell.ImageView.sd_setImage(with: URL.init(string: IMAGE_URL + "events/" + self.imageList[indexPath.item])!, placeholderImage: #imageLiteral(resourceName: "placeholder"))
        cell.deleteBtn.addTarget(self, action: #selector(deleteBtnTap), for: .touchUpInside)
        cell.deleteBtn.tag = indexPath.item
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
    @objc func deleteBtnTap(sender: UIButton) {
        let Alert = UIAlertController.init(title: "Alert!", message: "Are, You sure you want to remove this image?", preferredStyle: UIAlertController.Style.alert)
        Alert.addAction(UIAlertAction.init(title: "Yes", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction!) in
            self.imageList.remove(at: sender.tag)
            self.imageCollectionView.reloadData()
        }))
        Alert.addAction(UIAlertAction.init(title: "No", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction!) in
        }))
        self.present(Alert, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 80)
    }
}

extension AddEventViewController : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if textField == eventAddressTextField {
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
        let filter = GMSAutocompleteFilter()
        filter.type = .establishment
        let placesClient = GMSPlacesClient()
        placesClient.autocompleteQuery(userInfo, bounds: nil, filter: filter, callback: {(results, error) -> Void in
            if let error = error {
                print("Autocomplete error \(error)")
                self.searchResults.removeAll()
                return
            }
            self.searchResults.removeAll()
            for result in results!{
                if let result = result as? GMSAutocompletePrediction{
                    self.searchResults.append(result.attributedFullText.string)
                }
            }
            if self.searchResults.count>0{
                //                self.autoCompleteTableView.isHidden = false
                self.setupSelectionDropDown(arr: self.searchResults,textfield: self.eventAddressTextField)
                self.amountDropDown.reloadAllComponents()
            }
            else{
            }
        })
    }
    
    func setupSelectionDropDown(arr:[String],textfield:UITextField) {
        //selectionDropDown.show()
        amountDropDown.anchorView = textfield
        amountDropDown.width = textfield.frame.size.width
        amountDropDown.topOffset = CGPoint(x: 0, y: -40)
        amountDropDown.bottomOffset = CGPoint(x: 0, y: textfield.bounds.height + 10)
        // var idNum:Int = 0
        amountDropDown.dataSource = arr
        amountDropDown.show()
        amountDropDown.selectionAction = { [unowned self] (index, item) in
            if textfield == self.eventAddressTextField {
                textfield.text = item
//                self.timeZoneStr = ""
                let geocoder = CLGeocoder()
                var coordinates = CLLocationCoordinate2D()
                geocoder.geocodeAddressString(item) {
                    placemarks, error in
                    let placemark = placemarks?.first
                    print(item)
                    if placemark != nil {
                        coordinates.latitude = (placemark?.location?.coordinate.latitude)!
                        coordinates.longitude = (placemark?.location?.coordinate.longitude)!
                        self.latitudeStr = "\(coordinates.latitude)"
                        self.longitudeStr = "\(coordinates.longitude)"
                        self.eventAddressTextField.resignFirstResponder()
                        let pm = placemarks! as [CLPlacemark]
                        if pm.count > 0 {
                            let pm = placemarks![0]
//                            if pm.timeZone != nil {
//                                self.timeZoneStr = pm.timeZone!.identifier
//                            }
                            var addressString : String = ""
                            if pm.subLocality != nil {
                                self.street_address = pm.subLocality!
                                addressString = addressString + pm.subLocality! + ", "
                            }
                            if pm.thoroughfare != nil {
                                self.city = pm.locality!
                                addressString = addressString + pm.thoroughfare! + ", "
                            }
                            if pm.locality != nil {
                                self.state = pm.locality!
                                addressString = addressString + pm.locality! + ", "
                            }
                            if pm.country != nil {
                                self.country = pm.country!
                                addressString = addressString + pm.country! + ", "
                            }
                            if pm.postalCode != nil {
                                self.zipCodeStr = pm.postalCode!
                                addressString = addressString + pm.postalCode! + " "
                            }
                            else {
                                self.showPopUp(addressString: addressString)
                            }
                            self.eventAddressTextField.text = addressString
                            
                            self.getTimeZoneApi()
                        }
                    }
                }
            }
        }
    }
    
    func showPopUp(addressString:String) {
        var str = addressString
        let alert = UIAlertController(title: "Alert!", message: "Your Address ZipCode Not Found. Please Enter Manually!", preferredStyle: UIAlertController.Style.alert)
        alert.addTextField { (configurationTextField) in
            configurationTextField.textColor = UIColor.black
        }
        alert.addAction(UIAlertAction(title: "Done", style: UIAlertAction.Style.default, handler:{ (UIAlertAction)in
            if let textField = alert.textFields?.first {
                if !(ValidationManager.validateZipCode(zipCode: textField.text!)) {
                    let Alert = UIAlertController(title: "Error", message: "Please enter a valid zipCode.", preferredStyle: UIAlertController.Style.alert)
                    Alert.addAction(UIKit.UIAlertAction(title: "Okay", style: .default, handler: { (action: UIAlertAction!) in
                        self.showPopUp(addressString: addressString)
                    }))
                    Alert.addAction(UIKit.UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction!) in
                        self.eventAddressTextField.text = ""
                    }))
                    self.present(Alert, animated: true, completion: nil)
                }
                else {
                    self.zipCodeStr = textField.text!
                    str = addressString + self.zipCodeStr
                    self.eventAddressTextField.text = str
                }
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func getTimeZoneApi() {
            if Reachability.isConnectedToNetwork() {
            showProgressOnView(self.view)
            ServerClass.sharedInstance.getTimeZoneGoogleApi(path: "https://maps.googleapis.com/maps/api/timezone/json?location=\(self.latitudeStr),\(self.longitudeStr)&timestamp=\(NSDate().timeIntervalSince1970)&key=\(GOOGLE_API_KEY)", successBlock: { (json) in
                print(json)
                hideAllProgressOnView(self.view)
                let status = json["status"].stringValue
                if status  == "OK"  {
                   self.timeZoneStr = json["timeZoneId"].stringValue
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

extension AddEventViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func openCamera() {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else{
            UIAlertController.showInfoAlertWithTitle("Warning", message: "You don't have camera", buttonTitle: "Okay")
        }
    }
    
    func openGallary() {
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.navigationBar.tintColor = .black
        self.present(imagePicker, animated: true, completion: nil)
    }
    
     func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.editedImage] as? UIImage {
            self.logoImageView.isHidden = false
            self.logoImageView.image = pickedImage
            self.uploadImageApi(image: pickedImage, index : 0, type: "logo")
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
