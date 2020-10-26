//
//  ProfileViewController.swift
//  VanityPass
//
//  Created by Amit on 15/03/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit
import DropDown
import YangMingShan

class ProfileViewController: UIViewController {
    @IBOutlet weak var customNavigationBar: CustomNavigationBarForDrawer!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var dobTextField: UITextField!
    @IBOutlet weak var currentAgencyTextField: UITextField!
    @IBOutlet weak var motherAgencyTextField: UITextField!
    @IBOutlet weak var homeTownTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var instagramTextField: UITextField!
    @IBOutlet weak var mobileNumberTextField: UITextField!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var cameraBtn: UIButton!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var countryBtn: UIButton!
    @IBOutlet weak var deleteProfileBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var uploadPolaroidsBtn : UIButton!
    @IBOutlet weak var imageCollectionViewHeightConstraints: NSLayoutConstraint!
    let imagePicker = UIImagePickerController()
    let datePicker: UIDatePicker = UIDatePicker()
    var profilePicStr : String = ""
    var polaroidsList : [String] = []
    var countryList : [String] = []
    let dropDown = DropDown()
    var editBool : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customNavigationBar.titleLabel.text = "Profile"
        imagePicker.delegate = self
        editBtn.isHidden = false
        saveBtn.isHidden = true
        deleteProfileBtn.isHidden = true
        cameraBtn.isHidden = true
        editBool = false
        self.firstNameTextField.isUserInteractionEnabled = false
        self.lastNameTextField.isUserInteractionEnabled = false
        self.emailTextField.isUserInteractionEnabled = false
        self.dobTextField.isUserInteractionEnabled = false
        self.currentAgencyTextField.isUserInteractionEnabled = false
        self.motherAgencyTextField.isUserInteractionEnabled = false
        self.homeTownTextField.isUserInteractionEnabled = false
        self.countryTextField.isUserInteractionEnabled = false
        self.countryBtn.isUserInteractionEnabled = false
        self.instagramTextField.isUserInteractionEnabled = false
        self.mobileNumberTextField.isUserInteractionEnabled = false
        self.uploadPolaroidsBtn.isUserInteractionEnabled = false
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
    
    @IBAction func dobBtnTap(_ sender: Any) {
        self.createDateandTimePicker()
    }
    
    @IBAction func deleteBtnTap(_ sender: Any) {
        let alert = UIAlertController(title: "Are you sure you want to delete your account?", message: nil, preferredStyle: .alert)
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: { (action) in })
        let yesAction = UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            self.deleteMyAccount()
        })
        alert.addAction(noAction)
        alert.addAction(yesAction)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
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
    
    func deleteMyAccount() {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(self.view)
            ServerClass.sharedInstance.getRequestWithUrlParameters([:], path: BASE_URL + PROJECT_URL.DELETE_MODEL_PROFILE_API, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(self.view)
                let success = json["success"].stringValue
                if success  == "true"  {
                    UIAlertController.showInfoAlertWithTitle("Message", message: json["message"].stringValue, buttonTitle: "Okay")
                    logoutUser()
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
            ServerClass.sharedInstance.getRequestWithUrlParameters([:], path: BASE_URL + PROJECT_URL.GET_MODEL_PROFILE_API, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(self.view)
                let success = json["success"].stringValue
                if success  == "true"  {
                    sideMenuViewController.hideLeftViewAnimated()
                    self.profilePicStr = json["data"]["profile_pic"].stringValue
                    self.profileImageView.sd_setImage(with:  URL.init(string: IMAGE_URL + "users/" + json["data"]["profile_pic"].stringValue), placeholderImage: #imageLiteral(resourceName: "userImage"))
                    self.firstNameTextField.text = json["data"]["first_name"].stringValue
                    self.lastNameTextField.text = json["data"]["last_name"].stringValue
                    self.emailTextField.text = json["data"]["email"].stringValue
                    self.dobTextField.text = json["data"]["date_of_birth"].stringValue
                    self.currentAgencyTextField.text = json["data"]["current_agency"].stringValue
                    self.motherAgencyTextField.text = json["data"]["mother_agency"].stringValue
                    self.homeTownTextField.text = json["data"]["address"].stringValue
                    self.countryTextField.text = json["data"]["country"].stringValue
                    self.instagramTextField.text = json["data"]["social_instagram_link"].stringValue
                    self.mobileNumberTextField.text = json["data"]["phone"].stringValue
                    self.polaroidsList.removeAll()
                    for i in 0..<json["data"]["polaroids"].count {
                        self.polaroidsList.append(json["data"]["polaroids"][i].stringValue)
                    }
                    if self.polaroidsList.count == 0 {
                        self.imageCollectionViewHeightConstraints.constant = 0
                    }
                    else {
                        self.imageCollectionViewHeightConstraints.constant = 80
                    }
                    self.editBool = false
                    self.imageCollectionView.reloadData()
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
        deleteProfileBtn.isHidden = false
        editBtn.isHidden = true
        cameraBtn.isHidden = false
        self.firstNameTextField.isUserInteractionEnabled = true
        self.lastNameTextField.isUserInteractionEnabled = true
        self.dobTextField.isUserInteractionEnabled = true
        self.currentAgencyTextField.isUserInteractionEnabled = true
        self.motherAgencyTextField.isUserInteractionEnabled = true
        self.homeTownTextField.isUserInteractionEnabled = true
        self.countryTextField.isUserInteractionEnabled = true
        self.countryBtn.isUserInteractionEnabled = true
        self.instagramTextField.isUserInteractionEnabled = true
        self.mobileNumberTextField.isUserInteractionEnabled = true
        self.uploadPolaroidsBtn.isUserInteractionEnabled = true
        self.editBool = true
        self.imageCollectionView.reloadData()
    }
    
    @IBAction func saveBtnTap(_ sender: UIButton) {
        if UserDefaults.standard.bool(forKey: USER_DEFAULTS_KEYS.IS_LOGIN) == true {
            if UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.USER_TYPE) as! String == "model" {
                self.editProfileApi()
            }
        }
    }
    
    func editProfileApi() {
        if (firstNameTextField.text?.isEmpty)! {
            showInvalidInputAlert("First Name")
        }
        else if (lastNameTextField.text?.isEmpty)! {
            showInvalidInputAlert("Last Name")
        }
        else if (dobTextField.text?.isEmpty)! {
            showInvalidInputAlert("Date Of Birth")
        }
        else if (currentAgencyTextField.text?.isEmpty)! {
            showInvalidInputAlert("Current Agency")
        }
        else if (motherAgencyTextField.text?.isEmpty)! {
            showInvalidInputAlert("Mother Agency")
        }
        else if (homeTownTextField.text?.isEmpty)! {
            showInvalidInputAlert("Home Town")
        }
        else if (countryTextField.text?.isEmpty)! {
            showInvalidInputAlert("Country")
        }
        else if (instagramTextField.text?.isEmpty)! {
            showInvalidInputAlert("Instagram Link")
        }
        else if (mobileNumberTextField.text?.isEmpty)! {
            showInvalidInputAlert("Mobile Number")
        }
            //        else if frontImageStr == "" {
            //            UIAlertController.showInfoAlertWithTitle("Error", message: String(format:"Please attach Composite Front Card Image."), buttonTitle: "Okay")
            //        }
            //        else if backImageStr == "" {
            //            UIAlertController.showInfoAlertWithTitle("Error", message: String(format:"Please attach Composite Back Card Image."), buttonTitle: "Okay")
            //        }
        else if polaroidsList.count == 0 {
            UIAlertController.showInfoAlertWithTitle("Error", message: String(format:"Please attach at least one polaroids image file."), buttonTitle: "Okay")
        }
        else {
            let param1 : [String : Any] = ["first_name" : firstNameTextField.text!,
                                           "last_name" : lastNameTextField.text!,
                                           "profile_pic" : profilePicStr,
                                           "phone" : mobileNumberTextField.text!,
                                           "date_of_birth" : dobTextField.text!,
                                           "current_agency" : currentAgencyTextField.text!,
                                           "mother_agency" : motherAgencyTextField.text!,
                                           "address" : homeTownTextField.text!,
                                           "country" : countryTextField.text!,
                                           "social_instagram_link" : instagramTextField.text!,
                                           "polaroids":polaroidsList
                                           ]
            if Reachability.isConnectedToNetwork() {
                showProgressOnView(self.view)
                print(param1)
                ServerClass.sharedInstance.postRequestWithUrlParameters(param1, path: BASE_URL + PROJECT_URL.EDIT_MODEL_PROFILE_API, successBlock: { (json) in
                    print(json)
                    hideAllProgressOnView(self.view)
                    let success = json["success"].stringValue
                    if success  == "true"  {
                        UIAlertController.showInfoAlertWithTitle("Message", message: json["message"].stringValue, buttonTitle: "Okay")
                        self.getProfile()
                        self.firstNameTextField.isUserInteractionEnabled = false
                        self.lastNameTextField.isUserInteractionEnabled = false
                        self.dobTextField.isUserInteractionEnabled = false
                        self.currentAgencyTextField.isUserInteractionEnabled = false
                        self.motherAgencyTextField.isUserInteractionEnabled = false
                        self.homeTownTextField.isUserInteractionEnabled = false
                        self.countryTextField.isUserInteractionEnabled = false
                        self.countryBtn.isUserInteractionEnabled = false
                        self.instagramTextField.isUserInteractionEnabled = false
                        self.mobileNumberTextField.isUserInteractionEnabled = false
                        self.uploadPolaroidsBtn.isUserInteractionEnabled = false
                        self.editBtn.isHidden = false
                        self.saveBtn.isHidden = true
                        self.cameraBtn.isHidden = true
                        self.deleteProfileBtn.isHidden = true
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
            ServerClass.sharedInstance.sendImageMultipartRequestToServerWithToken(apiUrlStr: BASE_URL + PROJECT_URL.EDIT_MODEL_PROFILE_PIC_API, imageKeyName: "file", imageUrl: imageToUploadURL, successBlock: {(json) in
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

extension ProfileViewController {
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

extension ProfileViewController : YMSPhotoPickerViewControllerDelegate {
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

extension ProfileViewController : UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return polaroidsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ServiceImageCollectionViewCell", for: indexPath as IndexPath) as! ServiceImageCollectionViewCell
        cell.ImageView.sd_setImage(with: URL.init(string: IMAGE_URL + "users/" + self.polaroidsList[indexPath.item])!, placeholderImage: #imageLiteral(resourceName: "placeholder"))
        if editBool == true {
            cell.deleteBtn.isHidden = false
        }
        else {
            cell.deleteBtn.isHidden = true
        }
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

extension ProfileViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
