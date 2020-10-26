//
//  PartnerProfileViewController.swift
//  VanityPass
//
//  Created by chawtech solutions on 4/1/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit
import DropDown
import YangMingShan

class PartnerProfileViewController: UIViewController {
    @IBOutlet weak var customNavigationBar: CustomNavigationBarForDrawer!
    @IBOutlet weak var businessNameTextField: UITextField!
    @IBOutlet weak var contactNameTextField: UITextField!
    @IBOutlet weak var contactNumberTextField: UITextField!
    @IBOutlet weak var websiteTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var businessAddressTextField: UITextField!
    @IBOutlet weak var instagramTextField: UITextField!
    @IBOutlet weak var facebookTextField: UITextField!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var cameraBtn: UIButton!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var countryBtn: UIButton!
        @IBOutlet weak var saveBtn: UIButton!
    let imagePicker = UIImagePickerController()
    var profilePicStr : String = ""
    var countryList : [String] = []
    let dropDown = DropDown()

    override func viewDidLoad() {
        super.viewDidLoad()
        customNavigationBar.titleLabel.text = "Profile"
        imagePicker.delegate = self
        editBtn.isHidden = false
        saveBtn.isHidden = true
        cameraBtn.isHidden = true
        self.businessNameTextField.isUserInteractionEnabled = false
        self.contactNameTextField.isUserInteractionEnabled = false
        self.contactNumberTextField.isUserInteractionEnabled = false
        self.websiteTextField.isUserInteractionEnabled = false
        self.countryTextField.isUserInteractionEnabled = false
        self.countryBtn.isUserInteractionEnabled = false
        self.cityTextField.isUserInteractionEnabled = false
        self.businessAddressTextField.isUserInteractionEnabled = false
        self.instagramTextField.isUserInteractionEnabled = false
        self.facebookTextField.isUserInteractionEnabled = false
        self.getCountryListApi()

        if UserDefaults.standard.bool(forKey: USER_DEFAULTS_KEYS.IS_LOGIN) == true {
            self.getProfile()
        }
    }
    
    @IBAction func cameraBtnTap(_ sender: Any) {
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
//        self.dropDown.selectRow(arr.firstIndex(where: { $0 == textfield.text!})!)
        dropDown.show()
        dropDown.selectionBackgroundColor = UIColor.lightGray
        dropDown.selectionAction = { [unowned self] (index, item) in
            if textfield == self.countryTextField {
                self.countryTextField.text = self.countryList[index]
            }
        }
        dropDown.reloadAllComponents()
    }
    
    @IBAction func countryBtnTap(_ sender: Any) {
        self.setupDropDown(arr: countryList, textfield: self.countryTextField)
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
    
    
    func getProfile() {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(self.view)
            ServerClass.sharedInstance.getRequestWithUrlParameters([:], path: BASE_URL + PROJECT_URL.GET_PARTNER_PROFILE_API, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(self.view)
                let success = json["success"].stringValue
                if success  == "true"  {
                    sideMenuViewController.hideLeftViewAnimated()
                    self.profilePicStr = json["data"]["profile_pic"].stringValue
                    self.profileImageView.sd_setImage(with:  URL.init(string: IMAGE_URL + "users/" + json["data"]["profile_pic"].stringValue), placeholderImage: #imageLiteral(resourceName: "userImage"))
                    self.businessNameTextField.text = json["data"]["company"].stringValue
                    self.contactNameTextField.text = json["data"]["first_name"].stringValue
                    self.contactNumberTextField.text = json["data"]["phone"].stringValue
                    self.websiteTextField.text = json["data"]["website"].stringValue
                    self.emailTextField.text = json["data"]["email"].stringValue
                    self.countryTextField.text = json["data"]["country"].stringValue
                    self.cityTextField.text = json["data"]["city"].stringValue
                    self.businessAddressTextField.text = json["data"]["address"].stringValue
                    self.instagramTextField.text = json["data"]["social_instagram_link"].stringValue
                    self.facebookTextField.text = json["data"]["social_facebook_link"].stringValue
                    
                    UserDefaults.standard.setValue(json["data"]["first_name"].stringValue + " " + json["data"]["last_name"].stringValue, forKey: USER_DEFAULTS_KEYS.USER_NAME)
                    UserDefaults.standard.setValue(json["data"]["profile_pic"].stringValue, forKey: USER_DEFAULTS_KEYS.USER_IMAGE)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SIDE_MENU"), object: nil, userInfo: ["sideMeneKey" : false])
                }
                else {
                    UIAlertController.showInfoAlertWithTitle("Message", message: json["message"].stringValue, buttonTitle: "Okay")
                }
            }, errorBlock: { (NSError) in
                hideAllProgressOnView(self.view)
                UIAlertController.showInfoAlertWithTitle("Alert", message: kUnexpectedErrorAlertString, buttonTitle: "Okay")
            })
        }
        else{
            hideAllProgressOnView(self.view)
            UIAlertController.showInfoAlertWithTitle("Alert", message: "Please Check internet connection", buttonTitle: "Okay")
        }
    }
    
    @IBAction func editBtnTap(_ sender: UIButton) {
        saveBtn.isHidden = false
        editBtn.isHidden = true
        cameraBtn.isHidden = false
        self.businessNameTextField.isUserInteractionEnabled = true
        self.contactNameTextField.isUserInteractionEnabled = true
        self.contactNumberTextField.isUserInteractionEnabled = true
        self.websiteTextField.isUserInteractionEnabled = true
        self.countryTextField.isUserInteractionEnabled = true
        self.countryBtn.isUserInteractionEnabled = true
        self.cityTextField.isUserInteractionEnabled = true
        self.cityTextField.isUserInteractionEnabled = true
        self.businessAddressTextField.isUserInteractionEnabled = true
        self.instagramTextField.isUserInteractionEnabled = true
        self.facebookTextField.isUserInteractionEnabled = true
    }
    
    @IBAction func changePasswordBtnTap(_ sender: UIButton) {
        self.navigationController?.pushViewController(UIStoryboard.changePasswordViewController(), animated: true)
    }
    
    @IBAction func saveBtnTap(_ sender: UIButton) {
        if UserDefaults.standard.bool(forKey: USER_DEFAULTS_KEYS.IS_LOGIN) == true {
            self.editProfileApi()
        }
    }
    
    func editProfileApi() {
        if (businessNameTextField.text?.isEmpty)! {
            showInvalidInputAlert("Business Name")
        }
        else if (contactNameTextField.text?.isEmpty)! {
            showInvalidInputAlert("Contact Name")
        }
        else if (contactNumberTextField.text?.isEmpty)! {
            showInvalidInputAlert("Contact Number")
        }
        else if (websiteTextField.text?.isEmpty)! {
            showInvalidInputAlert("Website")
        }
        else if (emailTextField.text?.isEmpty)! {
            showInvalidInputAlert("Email")
        }
        else if (countryTextField.text?.isEmpty)! {
            showInvalidInputAlert("Country")
        }
        else if (cityTextField.text?.isEmpty)! {
            showInvalidInputAlert("City")
        }
        else if (businessAddressTextField.text?.isEmpty)! {
            showInvalidInputAlert("Business Address")
        }
        else if (instagramTextField.text?.isEmpty)! {
            showInvalidInputAlert("Instagram Link")
        }
        else if (facebookTextField.text?.isEmpty)! {
            showInvalidInputAlert("Facebook")
        }
        else {
            let param1 : [String : Any] = ["company" : businessNameTextField.text!,
                                           "first_name" : contactNameTextField.text!,
                                           "profile_pic" : profilePicStr,
                                           "phone" : contactNumberTextField.text!,
                                           "website" : websiteTextField.text!,
                                           "country" : countryTextField.text!,
                                           "city" : cityTextField.text!,
                                           "address" : businessAddressTextField.text!,
                                           "social_instagram_link" : instagramTextField.text!,
                                           "social_facebook_link" : facebookTextField.text!
            ]
            if Reachability.isConnectedToNetwork() {
                showProgressOnView(self.view)
                print(param1)
                ServerClass.sharedInstance.postRequestWithUrlParameters(param1, path: BASE_URL + PROJECT_URL.EDIT_PARTNER_PROFILE_API, successBlock: { (json) in
                    print(json)
                    hideAllProgressOnView(self.view)
                    let success = json["success"].stringValue
                    if success  == "true"  {
                        UIAlertController.showInfoAlertWithTitle("Message", message: json["message"].stringValue, buttonTitle: "Okay")
                        self.getProfile()
                        self.businessNameTextField.isUserInteractionEnabled = false
                        self.contactNameTextField.isUserInteractionEnabled = false
                        self.contactNumberTextField.isUserInteractionEnabled = false
                        self.websiteTextField.isUserInteractionEnabled = false
                        self.countryTextField.isUserInteractionEnabled = false
                        self.countryBtn.isUserInteractionEnabled = false
                        self.cityTextField.isUserInteractionEnabled = false
                        self.businessAddressTextField.isUserInteractionEnabled = false
                        self.instagramTextField.isUserInteractionEnabled = false
                        self.facebookTextField.isUserInteractionEnabled = false
                        self.editBtn.isHidden = false
                        self.saveBtn.isHidden = true
                        self.cameraBtn.isHidden = true
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
    
    func uploadProfileImageApi(image:UIImage) {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(self.view)
            saveImageDocumentDirectory(usedImage: image, nameStr : "file.png")
            let imageToUploadURL = URL(fileURLWithPath: (getDirectoryPath() as NSString).appendingPathComponent("file.png"))
            ServerClass.sharedInstance.sendImageMultipartRequestToServerWithToken(apiUrlStr: BASE_URL + PROJECT_URL.EDIT_PARTNER_PROFILE_PIC_API, imageKeyName: "file", imageUrl: imageToUploadURL, successBlock: {(json) in
                print(json)
                hideAllProgressOnView(self.view)
                let success = json["success"].stringValue
                if success  == "true"  {
                    self.profilePicStr = json["data"]["filename"].stringValue
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

extension PartnerProfileViewController : YMSPhotoPickerViewControllerDelegate {
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
//            self.profileImageView.image = image
//            self.uploadProfileImageApi(image: image)
//        }
//    }
}

extension PartnerProfileViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
            self.profileImageView.image = pickedImage
            self.uploadProfileImageApi(image: pickedImage)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
