//
//  RegistrationFirstViewController.swift
//  VanityPass
//
//  Created by Amit on 05/03/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit
import YangMingShan
import DropDown

class RegistrationFirstViewController: UIViewController {
    @IBOutlet weak var firstNameTxtField: UITextField!
    @IBOutlet weak var lastNameTxtField: UITextField!
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var dobTextField: UITextField!
    @IBOutlet weak var currentAgencyTxtField: UITextField!
    @IBOutlet weak var motherAgencyTxtField: UITextField!
    @IBOutlet weak var homeTownTxtField: UITextField!
    @IBOutlet weak var countryTxtField: UITextField!
    @IBOutlet weak var instagramTxtField: UITextField!
    @IBOutlet weak var mobileNumberTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var imageCollectionViewHeightConstraints: NSLayoutConstraint!
    var countryList : [String] = []
    let datePicker: UIDatePicker = UIDatePicker()
    let dropDown = DropDown()
    let imagePicker = UIImagePickerController()
    var polaroidsList : [String] = []
    var fcmKey : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getCountryListApi()
        if self.polaroidsList.count == 0 {
            self.imageCollectionViewHeightConstraints.constant = 0
        }
        else {
            self.imageCollectionViewHeightConstraints.constant = 80
        }
    }
    
    @IBAction func backBtnTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
            self.dropDown
        ]
    }()
    
    func setupDropDown(arr:[String],textfield:UITextField) {
        dropDown.anchorView = textfield
        dropDown.bottomOffset = CGPoint(x: 0, y: textfield.bounds.height+10)
        dropDown.dataSource = arr
        dropDown.show()
        dropDown.selectionBackgroundColor = UIColor.lightGray
        dropDown.selectionAction = { [unowned self] (index, item) in
            if textfield == self.countryTxtField {
                self.countryTxtField.text = self.countryList[index]
            }
        }
        dropDown.reloadAllComponents()
    }
    
    @IBAction func countryBtnTap(_ sender: Any) {
        self.setupDropDown(arr: countryList, textfield: self.countryTxtField)
    }
    
    func getCountryListApi() {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(self.view)
            ServerClass.sharedInstance.getRequestWithUrlParameters([:], path: BASE_URL + PROJECT_URL.COUNTRY_LIST_API, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(self.view)
                let success = json["success"].stringValue
                if success  == "true"  {
                    for i in 0..<json["data"].count {
                        self.countryList.append(json["data"][i]["name"].stringValue)
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
    
    @IBAction func uploadPolaroidsBtnTap(_ sender: Any) {
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
    
    @IBAction func nextBtnTap(_ sender: Any) {
        if (firstNameTxtField.text?.isEmpty)! {
            showInvalidInputAlert(firstNameTxtField.placeholder!)
        }
        else if (lastNameTxtField.text?.isEmpty)! {
            showInvalidInputAlert(lastNameTxtField.placeholder!)
        }
        else if !(ValidationManager.validateEmail(email: emailTxtField.text!)) {
            showInvalidInputAlert(emailTxtField.placeholder!)
        }
        else if (dobTextField.text?.isEmpty)! {
            showInvalidInputAlert(dobTextField.placeholder!)
        }
        else if (currentAgencyTxtField.text?.isEmpty)! {
            showInvalidInputAlert(currentAgencyTxtField.placeholder!)
        }
        else if (motherAgencyTxtField.text?.isEmpty)! {
            showInvalidInputAlert(motherAgencyTxtField.placeholder!)
        }
        else if (homeTownTxtField.text?.isEmpty)! {
            showInvalidInputAlert(homeTownTxtField.placeholder!)
        }
        else if (countryTxtField.text?.isEmpty)! {
            showInvalidInputAlert(countryTxtField.placeholder!)
        }
        else if (instagramTxtField.text?.isEmpty)! {
            showInvalidInputAlert(instagramTxtField.placeholder!)
        }
        else if (mobileNumberTxtField.text?.isEmpty)! {
            showInvalidInputAlert(mobileNumberTxtField.placeholder!)
        }
        else if ValidationManager.validatePassword(password: passwordTxtField.text!) == 0 {
            showPasswordLengthAlert()
        }
        else if ValidationManager.validatePassword(password: passwordTxtField.text!) == 1 {
            showPasswordWhiteSpaceAlert()
        }
        else if polaroidsList.count == 0 {
            UIAlertController.showInfoAlertWithTitle("Error", message: String(format:"Please attach at least one polaroids image file."), buttonTitle: "Okay")
        }
        else {
            if let objFcmKey = UserDefaults.standard.object(forKey: USER_DEFAULTS_KEYS.FCM_KEY) as? String {
                self.fcmKey = objFcmKey
            }
            let param1 : [String : Any] = ["first_name" : firstNameTxtField.text!,
                                           "last_name" : lastNameTxtField.text!,
                                           "email" : emailTxtField.text!,
                                           "phone" : mobileNumberTxtField.text!,
                                           "date_of_birth" : dobTextField.text!,
                                           "current_agency" : currentAgencyTxtField.text!,
                                           "mother_agency" : motherAgencyTxtField.text!,
                                           "address" : homeTownTxtField.text!,
                                           "country" : countryTxtField.text!,
                                           "social_instagram_link" : instagramTxtField.text!,
                                           "password" : passwordTxtField.text!,
                                           "composite_card_front_side" : "",
                                           "composite_card_back_side" : "",
                                           "polaroids":polaroidsList,
                                           "device" : "ios",
                                           "device_id" : (UIDevice.current.identifierForVendor?.uuidString)!,
                                           "fcm_key" : self.fcmKey!]
            let viewController = UIStoryboard.registerSecondViewController() 
            viewController.userType = "model"
            viewController.param1 = param1
            self.navigationController?.pushViewController(viewController, animated: true)
            
        }
    }
    
    @IBAction func dobBtnTap(_ sender: Any) {
        self.createDateandTimePicker()
    }
    
    func uploadImageApi(image:UIImage, index: Int) {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(self.view)
            saveImageDocumentDirectory(usedImage: image, nameStr : "file\(index).png")
            let imageToUploadURL = URL(fileURLWithPath: (getDirectoryPath() as NSString).appendingPathComponent("file\(index).png"))
            ServerClass.sharedInstance.sendMultipartRequestToServer(apiUrlStr: BASE_URL + PROJECT_URL.UPLOAD_FILE_API, imageKeyName: "file", imageUrl: imageToUploadURL, successBlock: {(json) in
                print(json)
                hideAllProgressOnView(self.view)
                let success = json["success"].stringValue
                if success  == "true"  {
                    self.polaroidsList.append(json["data"]["filename"].stringValue)
                    if self.polaroidsList.count == 0 {
                        self.imageCollectionViewHeightConstraints.constant = 0
                    }
                    else {
                        self.imageCollectionViewHeightConstraints.constant = 80
                    }
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
        else {
            hideAllProgressOnView(self.view)
            UIAlertController.showInfoAlertWithTitle("Alert", message: "Please Check internet connection", buttonTitle: "Okay")
        }
    }
}

extension RegistrationFirstViewController {
    func createDateandTimePicker() {
        // Posiiton date picket within a view
        datePicker.frame = CGRect(x: 10, y: 50, width: self.view.frame.width, height: 220)
        // Set some of UIDatePicker properties
        datePicker.datePickerMode = UIDatePicker.Mode.date
        datePicker.backgroundColor = UIColor.white
        datePicker.maximumDate = Date()
        // Add an event to call onDidChangeDate function when value is changed.
        datePicker.addTarget(self, action: #selector(RegistrationFirstViewController.datePickerValueChanged(_:)), for: .valueChanged)
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.backgroundColor = UIColor.black
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(RegistrationFirstViewController.donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        dobTextField?.inputView = datePicker
        dobTextField?.inputAccessoryView = toolBar
        dobTextField?.becomeFirstResponder()
    }
    
    //MARK: Done Picker Method
    @objc func donePicker() {
        //            let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        //        let result = formatter.string(from: date)
        //        activeField?.text = result
        dobTextField?.resignFirstResponder()
        datePicker.removeFromSuperview()
    }
    
    //MARK: DatePickerValueChanged Method
    @objc func datePickerValueChanged(_ sender: UIDatePicker){
        // Create date formatter
        let dateFormatter: DateFormatter = DateFormatter()
        // Set date format
        dateFormatter.dateFormat = "yyyy-MM-dd"
        // Apply date format
        let selectedDate = dateFormatter.string(from: sender.date)
        print("Selected value \(selectedDate)")
        dobTextField?.text = selectedDate
    }
}

extension RegistrationFirstViewController : YMSPhotoPickerViewControllerDelegate {
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
    
    func photoPickerViewController(_ picker: YMSPhotoPickerViewController!, didFinishPickingImages photoAssets: [PHAsset]!) {
        // Remember images you get here is PHAsset array, you need to implement PHImageManager to get UIImage data by yourself
        picker.dismiss(animated: true) {
//            let manager = PHImageManager.default()
//            let option = PHImageRequestOptions()
//            option.isSynchronous = true
            //            self.polaroidsList.removeAll()
            for i in 0..<photoAssets.count {
                let asset: PHAsset = photoAssets[i]
//                manager.requestImage(for: asset, targetSize: CGSize(width: 100.0, height: 100.0), contentMode: .aspectFit, options: option, resultHandler: {(image, info)->Void in
//                    self.uploadImageApi(image: image!, index : i)
//                })
                var img: UIImage?
                let manager = PHImageManager.default()
                let options = PHImageRequestOptions()
                options.version = .original
                options.isSynchronous = true
                manager.requestImageData(for: asset, options: options) { data, _, _, _ in
                    if let data = data {
                        img = UIImage(data: data)
                        self.uploadImageApi(image: img!, index : i)
                    }
                }
            }
            self.imageCollectionView.reloadData()
        }
    }
}

extension RegistrationFirstViewController : UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return polaroidsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ServiceImageCollectionViewCell", for: indexPath as IndexPath) as! ServiceImageCollectionViewCell
        cell.ImageView.sd_setImage(with: URL.init(string: IMAGE_URL + "users/" + self.polaroidsList[indexPath.item])!, placeholderImage: #imageLiteral(resourceName: "placeholder"))
        cell.deleteBtn.addTarget(self, action: #selector(deleteBtnTap), for: .touchUpInside)
        cell.deleteBtn.tag = indexPath.item
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
    @objc func deleteBtnTap(sender: UIButton) {
        let Alert = UIAlertController.init(title: "Alert!", message: "Are, You sure you want to remove this image?", preferredStyle: UIAlertController.Style.alert)
        Alert.addAction(UIAlertAction.init(title: "Yes", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction!) in
            self.polaroidsList.remove(at: sender.tag)
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

