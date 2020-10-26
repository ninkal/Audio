//
//  TransParent1ViewController.swift
//  SwiftProject
//
//  Created by ChawtechSolutions on 22/12/18.
//  Copyright © 2018 ChawtechSolutions. All rights reserved.
//

import UIKit
import DropDown
import YangMingShan

protocol closeTransparent {
    func completeOffer(offerId:String)
}

class TransParent1ViewController: UIViewController {
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var numberOfTicketView : UIView!
    @IBOutlet weak var venueNameTextField: UITextField!
    @IBOutlet weak var offerNameTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var numberOfTicketTextField: UITextField!
    @IBOutlet weak var expirationTimeTextField: UITextField!
    @IBOutlet weak var dailyBtn: UIButton!
    @IBOutlet weak var weeklyBtn: UIButton!
    @IBOutlet weak var monthlyBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var venueView:UIView!
    @IBOutlet weak var alertViewHeightConstraints:NSLayoutConstraint!
    let imagePicker = UIImagePickerController()
    var eventList : [EventStruct] = []
    var vanueList : [String] = []
    let datePicker: UIDatePicker = UIDatePicker()
    var delegate : closeTransparent?
    var event:EventStruct!
    var offer:OfferStruct!
    let dropDown = DropDown()
    var logoStr : String = ""
    var eventIdStr : String = ""
    
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
            self.dropDown
        ]
    }()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("memory fullllll")
    }
    
    func setupDropDown(arr:[String],textfield:UITextField) {
        dropDown.anchorView = textfield
        dropDown.bottomOffset = CGPoint(x: 0, y: textfield.bounds.height+10)
        dropDown.dataSource = arr
        dropDown.show()
        dropDown.selectionBackgroundColor = UIColor.lightGray
        dropDown.selectionAction = { [unowned self] (index, item) in
            if textfield == self.venueNameTextField {
                self.venueNameTextField.text = self.vanueList[index]
                self.eventIdStr = self.eventList.filter{ $0.name == self.vanueList[index] }.first!.id
            }
        }
        dropDown.reloadAllComponents()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        if event != nil {
            self.eventIdStr = event.id
            venueView.isHidden = true
            self.alertViewHeightConstraints.constant = 540 - 40
            venueNameTextField.text = event.name
        }
        else {
            venueView.isHidden = false
            self.alertViewHeightConstraints.constant = 540
            self.getEventListApi()
        }
        if offer == nil {
            numberOfTicketView.isHidden = false
            expirationTimeTextField.text = Date().toString(dateFormat: "dd-MM-yyyy")
            saveBtn.setTitle("SAVE", for: .normal)
            logoImageView.isHidden = true
        }
        else {
            logoImageView.isHidden = false
            offerNameTextField.text = offer.name
            descriptionTextView.text = offer.description
            venueNameTextField.text = event.name
            if offer.frequency == "Daily" {
                dailyBtn.setImage(UIImage.init(named: "checkBoxPinkSelected"), for: .normal)
                weeklyBtn.setImage(UIImage.init(named: "checkBoxPinkUnSelected"), for: .normal)
                monthlyBtn.setImage(UIImage.init(named: "checkBoxPinkUnSelected"), for: .normal)
            }
            else if offer.frequency == "Weekly" {
                weeklyBtn.setImage(UIImage.init(named: "checkBoxPinkSelected"), for: .normal)
                monthlyBtn.setImage(UIImage.init(named: "checkBoxPinkUnSelected"), for: .normal)
                dailyBtn.setImage(UIImage.init(named: "checkBoxPinkUnSelected"), for: .normal)
            }
            else {
                monthlyBtn.setImage(UIImage.init(named: "checkBoxPinkSelected"), for: .normal)
                weeklyBtn.setImage(UIImage.init(named: "checkBoxPinkUnSelected"), for: .normal)
                dailyBtn.setImage(UIImage.init(named: "checkBoxPinkUnSelected"), for: .normal)
            }
            numberOfTicketTextField.text = offer.ticket_available
            logoImageView.sd_setImage(with: URL.init(string: IMAGE_URL + "events/" + offer.thumbnail), placeholderImage: #imageLiteral(resourceName: "add_Plus"))
            logoStr = offer.thumbnail
            let arr : [String] = offer.expire_date.components(separatedBy: " ")
            if arr.count > 0 {
                self.expirationTimeTextField.text = arr[0]
            }  
            numberOfTicketView.isHidden = true
            saveBtn.setTitle("UPDATE", for: .normal)
        }
        
        let dimAlphaRedColor =  UIColor.black.withAlphaComponent(0.5)
        self.view.backgroundColor = dimAlphaRedColor
        view.isOpaque = true  
        alertView.layer.cornerRadius = 10.0
        alertView.layer.borderColor = UIColor.gray.cgColor
        alertView.layer.borderWidth = 0.5
        alertView.clipsToBounds = true
    }
    
    func getEventListApi() {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(self.view)
            ServerClass.sharedInstance.getRequestWithUrlParameters([:], path: BASE_URL + PROJECT_URL.GET_PARTNER_EVENT_LIST, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(self.view)
                let success = json["success"].stringValue
                if success  == "true"  {
                    self.eventList.removeAll()
                    for i in 0..<json["data"].count {
                        var galleryList : [String] = []
                        for j in 0..<json["data"][i]["galleries"].count {
                            galleryList.append(IMAGE_URL + "events/" + json["data"][i]["galleries"][j].stringValue)
                        }
                        self.eventList.append(EventStruct.init(id: json["data"][i]["id"].stringValue, organiser_name: json["data"][i]["organiser_name"].stringValue, organiser_logo: json["data"][i]["organiser_logo"].stringValue, name: json["data"][i]["name"].stringValue, description: json["data"][i]["description"].stringValue, user_id: json["data"][i]["user_id"].stringValue, address: json["data"][i]["address"].stringValue, latitude: json["data"][i]["latitude"].stringValue, longitude: json["data"][i]["longitude"].stringValue, phone1: json["data"][i]["phone1"].stringValue, phone2: json["data"][i]["phone2"].stringValue, city: json["data"][i]["city"].stringValue, pincode: json["data"][i]["pincode"].stringValue, state: json["data"][i]["state"].stringValue, country: json["data"][i]["country"].stringValue, opening_time: String(json["data"][i]["opening_time"].stringValue.prefix(5)), closing_time: String(json["data"][i]["closing_time"].stringValue.prefix(5)), thumbnail: json["data"][i]["thumbnail"].stringValue, galleries: galleryList, active: json["data"][i]["active"].stringValue, email: "", first_name: "", last_name: "", ticket_available: json["data"][i]["ticket_available"].stringValue, distance: "", timezone: json["data"][i]["timezone"].stringValue))
                        self.vanueList.append(json["data"][i]["name"].stringValue)
                    }
                    self.eventList.sort { $0.ticket_available > $1.ticket_available }
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
    
    @IBAction func venueNameBtnTap(_ sender: Any) {
        self.setupDropDown(arr: vanueList, textfield: venueNameTextField)
    }

    @IBAction func dissmissBtnTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveBtnTap(_ sender: Any) {
        var frequencyStr = ""
        if dailyBtn.currentImage == UIImage.init(named: "checkBoxPinkSelected") {
            frequencyStr = "Daily"
        }
        else if weeklyBtn.currentImage == UIImage.init(named: "checkBoxPinkSelected") {
            frequencyStr = "Weekly"
        }
        else {
            frequencyStr = "Monthly"
        }
        
        if (offerNameTextField.text?.isEmpty)! {
            presentAlert(message: offerNameTextField.placeholder!)
        }
        else if (descriptionTextView.text?.isEmpty)! || descriptionTextView.text == "Description" {
            presentAlert(message: "Description")
        }
        else if (numberOfTicketTextField.text?.isEmpty)! && offer == nil {
            presentAlert(message: numberOfTicketTextField.placeholder!)
        }
//        else if logoImageView.image == #imageLiteral(resourceName: "add_Plus") {
//            presentAlert(message: "Offer Logo")
//        }
        else if frequencyStr == "" {
            presentAlert(message: "Frequency")
        }
        else if (expirationTimeTextField.text?.isEmpty)! {
            presentAlert(message: expirationTimeTextField.placeholder!)
        }
        else {
            if Reachability.isConnectedToNetwork() {
                showProgressOnView(self.view)
                var param1:[String:Any] = [
                    "event_id":eventIdStr,
                    "name":offerNameTextField.text!,
                    "description":descriptionTextView.text!,
                    "frequency":frequencyStr,
                    "thumbnail":logoStr,
                    "expire_date":expirationTimeTextField.text! + " " + "23:59:59"
                ]
                if offer == nil {
                    param1.updateValue(numberOfTicketTextField.text!, forKey: "no_of_ticket")
                    print(param1)
                    ServerClass.sharedInstance.postRequestWithUrlParameters(param1, path: BASE_URL + PROJECT_URL.ADD_OFFER_API, successBlock: { (json) in
                        print(json)
                        hideAllProgressOnView(self.view) 
                        let success = json["success"].stringValue
                        if success  == "true"  {
                            UIAlertController.showInfoAlertWithTitle("Success", message: json["message"].stringValue, buttonTitle: "Okay")
                            self.dismiss(animated: true, completion: {
                                self.delegate?.completeOffer(offerId : json["data"]["insert_id"].stringValue)
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
                    param1.updateValue(offer.id, forKey: "id")
                    print(param1)
                    ServerClass.sharedInstance.postRequestWithUrlParameters(param1, path: BASE_URL + PROJECT_URL.EDIT_OFFER_API, successBlock: { (json) in
                        print(json)
                        hideAllProgressOnView(self.view)
                        let success = json["success"].stringValue
                        if success  == "true"  {
                            UIAlertController.showInfoAlertWithTitle("Success", message: json["message"].stringValue, buttonTitle: "Okay")
                            self.dismiss(animated: true, completion: {
                                self.delegate?.completeOffer(offerId : "")
                            })
//                            self.delegate?.completeOffer(offerId : self.offer.id)
                            self.delegate?.completeOffer(offerId : "")
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
    
    @IBAction func expirationTimeBtnTap(_ sender: Any) {
        self.createDatePicker()
    }
    
    @IBAction func dailyBtnTap(_ sender: UIButton) {
        if dailyBtn.currentImage == UIImage.init(named: "checkBoxPinkSelected") {
            dailyBtn.setImage(UIImage.init(named: "checkBoxPinkUnSelected"), for: .normal)
            weeklyBtn.setImage(UIImage.init(named: "checkBoxPinkUnSelected"), for: .normal)
            monthlyBtn.setImage(UIImage.init(named: "checkBoxPinkUnSelected"), for: .normal)
            expirationTimeTextField.text = ""
        }  
        else { 
            dailyBtn.setImage(UIImage.init(named: "checkBoxPinkSelected"), for: .normal)
            weeklyBtn.setImage(UIImage.init(named: "checkBoxPinkUnSelected"), for: .normal)
            monthlyBtn.setImage(UIImage.init(named: "checkBoxPinkUnSelected"), for: .normal)
            expirationTimeTextField.text = Date().toString(dateFormat: "dd-MM-yyyy")
        }
    }
    
    @IBAction func weeklyBtnTap(_ sender: UIButton) {
        if weeklyBtn.currentImage == UIImage.init(named: "checkBoxPinkSelected") {
            dailyBtn.setImage(UIImage.init(named: "checkBoxPinkUnSelected"), for: .normal)
            weeklyBtn.setImage(UIImage.init(named: "checkBoxPinkUnSelected"), for: .normal)
            monthlyBtn.setImage(UIImage.init(named: "checkBoxPinkUnSelected"), for: .normal)
            expirationTimeTextField.text = ""
        }
        else {
            weeklyBtn.setImage(UIImage.init(named: "checkBoxPinkSelected"), for: .normal)
            monthlyBtn.setImage(UIImage.init(named: "checkBoxPinkUnSelected"), for: .normal)
            dailyBtn.setImage(UIImage.init(named: "checkBoxPinkUnSelected"), for: .normal)
            expirationTimeTextField.text = Date().endOfWeek.toString(dateFormat: "dd-MM-yyyy")
        }
    }
    
    @IBAction func monthlyBtnTap(_ sender: UIButton) {
        if monthlyBtn.currentImage == UIImage.init(named: "checkBoxPinkSelected") {
            dailyBtn.setImage(UIImage.init(named: "checkBoxPinkUnSelected"), for: .normal)
            weeklyBtn.setImage(UIImage.init(named: "checkBoxPinkUnSelected"), for: .normal)
            monthlyBtn.setImage(UIImage.init(named: "checkBoxPinkUnSelected"), for: .normal)
            expirationTimeTextField.text = ""
        }
        else {
            monthlyBtn.setImage(UIImage.init(named: "checkBoxPinkSelected"), for: .normal)
            dailyBtn.setImage(UIImage.init(named: "checkBoxPinkUnSelected"), for: .normal)
            weeklyBtn.setImage(UIImage.init(named: "checkBoxPinkUnSelected"), for: .normal)
            expirationTimeTextField.text = Date().endOfMonth.toString(dateFormat: "dd-MM-yyyy")
        }
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
    
    func uploadImageApi(image:UIImage) {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(self.view)
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
            hideAllProgressOnView(self.view)
            UIAlertController.showInfoAlertWithTitle("Alert", message: "Please Check internet connection", buttonTitle: "Okay")
        }
    }
}

extension TransParent1ViewController {
    func presentAlert(message:String) {
        let alertController: UIAlertController =  UIAlertController.init(title: "Error", message: String(format:"Please enter a valid %@",message), preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Okay", style: .cancel, handler: { (action) in })
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

extension TransParent1ViewController : UITextViewDelegate {
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

extension TransParent1ViewController {
    func createDatePicker() {
        datePicker.minimumDate = Date()
        datePicker.frame = CGRect(x: 10, y: 50, width: self.view.frame.width, height: 220)
        // Set some of UIDatePicker properties
        datePicker.datePickerMode = UIDatePicker.Mode.dateAndTime
        datePicker.backgroundColor = UIColor.white
        // Add an event to call onDidChangeDate function when value is changed.
        datePicker.addTarget(self, action: #selector(TransParent1ViewController.datePickerValueChanged(_:)), for: .valueChanged)
        // Add DataPicker to the view
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.backgroundColor = UIColor.black
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(TransParent1ViewController.donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        expirationTimeTextField?.inputView = datePicker
        expirationTimeTextField?.inputAccessoryView = toolBar
        expirationTimeTextField?.becomeFirstResponder()
    }
    
    //MARK: DatePickerValueChanged Method
    @objc func datePickerValueChanged(_ sender: UIDatePicker){
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let selectedDate = dateFormatter.string(from: sender.date)
        print("Selected value \(selectedDate)")
        expirationTimeTextField?.text = selectedDate
    }
    
    //MARK: Done Picker Method
    @objc func donePicker() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        expirationTimeTextField?.resignFirstResponder()
        datePicker.removeFromSuperview()
    }
}

extension TransParent1ViewController : YMSPhotoPickerViewControllerDelegate {
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
//            self.uploadImageApi(image: image!)
//        }
//    }
}

extension TransParent1ViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
            self.uploadImageApi(image: pickedImage)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
