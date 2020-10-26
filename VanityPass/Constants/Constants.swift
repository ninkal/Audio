//
//  Constants.swift
//  TeamLink
//
//  Created by chawtech solutions on 3/01/18.
//  Copyright © 2018 chawtech solutions. All rights reserved.
//..................Latest Project Update On 15 Aug 2018..............................................

import UIKit
import MBProgressHUD
import LGSideMenuController
import SDWebImage
import AVFoundation
import SwiftyJSON

struct Level_Count_Struct
{
    var id:String = ""
    var name:String = ""
    var depth:String = ""
}

var levelCountArr = [Level_Count_Struct]()
struct Label_Sruct
{
    var level_id:String = ""
    var level_name:String = ""
    var jsonIndex:String = ""
}
var levelArr = [Label_Sruct]()
var levelNamesArr = [String]()
var selectedLevelId:String = "0"
var selectedLavelIdForServer:String = ""
var tempJson:JSON = JSON()
var tempJsonArr = [JSON]()



typealias FetchProfileResponse = (Bool) -> Void

let IS_IPHONE_5 = UIScreen.main.bounds.width == 320
let IS_IPHONE_6 = UIScreen.main.bounds.width == 375
let IS_IPHONE_6P = UIScreen.main.bounds.width == 414
let IS_IPAD = UIScreen.main.bounds.width >= 768.0
let IS_IPAD_Mini = UIScreen.main.bounds.width == 768.0
let IS_IPAD_Pro = UIScreen.main.bounds.width == 834.0
let IS_IPAD_Pro12 = UIScreen.main.bounds.width == 1024.0



let appDelegateInstance = UIApplication.shared.delegate as! AppDelegate

let sideMenuViewController = appDelegateInstance.window?.rootViewController as! LGSideMenuController

let kPasswordMinimumLength = 6 
let kPasswordMaximumLength = 15
let kUserFullNameMaximumLength = 56
let kPhoneNumberMaximumLength = 10
let kMessageMinimumLength = 25
let kMessageMaximumLength = 250

let selectionColor = UIColor(red: 36/255.0, green: 98/255.0, blue: 126/255.0, alpha: 1.0)

let kLostInternetConnectivityAlertString = "Your internet connection seems to be lost." as String
let kEmoticonInputErrorAlertString = "Emoticons aren't allowed." as String
let kPasswordLengthAlertString = NSString(format:"The Password should consist at least %d characters.",kPasswordMinimumLength) as String
let kPasswordWhiteSpaceAlertString = "The Password should not contain any whitespaces." as String
let kUnequalPasswordsAlertString = "Both Passwords do not match." as String
let kEqualPasswordsAlertString = "Old & New Password are same." as String
let kMessageTextViewPlaceholderString = "Write your experience..." as String
let kMesssageLengthAlertString = NSString(format:"The Message should consist at least %d-%d characters.",kMessageMinimumLength,kMessageMaximumLength) as String
let kUnexpectedErrorAlertString = "An unexpected error has occurred. Please try again." as String
let kNoDataFoundAlertString = "Sorry! No data found." as String
let kSignUpCaseAlertString = "Password should contains at least 1 Upper Case, 1 Lower Case, 1 number & 1 special character."

let BASE_URL = "https://app.vanitypass.com/"
let TRUST_BASE_URL = "https://app.vanitypass.com/"

let IMAGE_URL = "https://app.vanitypass.com/storage/app/"

let GOOGLE_API_KEY =  "AIzaSyDQe7PSF5M5do1bqXqlq0gQZoeaUgybJ4k" // "AIzaSyDXAVYTC4dhFZXph15PUD1Xcoqk3cjuSm8"  // "AIzaSyCn5PpXk6CnK1LfN_NVLk-cKHz49FF0BDs"
let FCM_SERVER_KEY = "AIzaSyCbyGXkDwnpyYbZlkkWuyGT3P5DUBDI3nA"


let X_API_KEY = "b8da15fba00ed2a4e4f20ee12c2ba98u"


struct PROJECT_URL {
    /****** COMMON API ******/
    static let LOGIN_API = "api/auth/login"
    static let SERVICE_LIST_API = "api/auth/services"
    static let FORGOT_PASSWORD_API = "api/auth/forgot"
    static let CONTACT_API = "api/page/contact"
    static let PRIVACY_API = "privacy-policy"
    static let ABOUT_API = "about-us"
    static let TERMS_OF_USE_API = "term-and-conditions"
    static let COUNTRY_LIST_API = "api/auth/countries"
    /****** MODEL API ******/
    static let MODEL_REGISTER_API = "api/model/auth/register"
    static let UPDATE_MODEL_FCM_API = "api/model/profile/fcmkey"
    static let CHANGE_PASSWORD_MODEL_API = "api/model/profile/changepass"
    static let UPLOAD_FILE_API = "api/model/auth/attach"
    static let EVENT_LIST_API = "api/model/event/list"
    static let GET_MODEL_EVENT_DETAILS = "api/model/event/get"
    static let OFFER_LIST_API = "api/model/offer/list"
    static let GET_OFFER_API = "api/model/offer/get"
    static let GET_MODEL_OFFER_TIME_AVAILABILITY_LIST = "api/model/offer/availabilityList"
    static let GET_MODEL_PROFILE_API = "api/model/profile/get"
    static let EDIT_MODEL_PROFILE_PIC_API = "api/model/profile/image"
    static let EDIT_MODEL_PROFILE_API = "api/model/profile/edit"
    static let RESERVE_OFFER_API = "api/model/offer/reserve"
    static let GET_RESERVED_OFFER_LIST_API = "api/model/profile/getReserverTickets"
    static let CANCEL_RESERVED_OFFER_API = "api/model/offer/cancelticket"
    static let DELETE_MODEL_PROFILE_API = "api/model/profile/delete"
    static let UPDATE_LOCATION_API = "api/model/profile/updatelocation"  
    /****** PARTNER API ******/
    static let PARTNER_REGISTER_API = "api/partner/auth/register"
    static let UPDATE_PARTNER_FCM_API = "api/partner/profile/fcmkey"
    static let CHANGE_PASSWORD_PARTNER_API = "api/partner/profile/changepass"
    static let GET_PARTNER_EVENT_LIST = "api/partner/event/list"
    static let GET_PARTNER_EVENT_DETAILS = "api/partner/event/get"
    static let ADD_EVENT_API = "api/partner/event/add"
    static let EDIT_EVENT_API = "api/partner/event/edit"
    static let UPLOAD_PARTNER_FILE_API = "api/partner/event/image"
    static let PARTNER_EVENT_OFFER_LIST_API = "api/partner/event/offers"
    static let GET_PARTNER_OFFER_DETAILS_API = "api/partner/event/offerget"
    static let ADD_OFFER_API = "api/partner/event/offeradd"
    static let EDIT_OFFER_API = "api/partner/event/offeredit"
    static let GET_PARTNER_OFFER_TIME_AVAILABILITY_LIST = "api/partner/event/offersAvailabilityList"
    static let ADD_OFFER_TIME_AVAILABILISTY_API = "api/partner/event/availabilityadd"
    static let EDIT_OFFER_TIME_AVAILABILISTY_API = "api/partner/event/availabilityedit"
    static let GET_PARTNER_PROFILE_API = "api/partner/profile/get"
    static let EDIT_PARTNER_PROFILE_PIC_API = "api/partner/profile/image"
    static let EDIT_PARTNER_PROFILE_API = "api/partner/profile/edit"
    static let SCAN_TICKET_PARTNER_API = "api/partner/event/scan_ticket"
    static let VERIFY_TICKET_PARTNER_API = "api/partner/event/verified_ticket"
}

struct USER_DEFAULTS_KEYS {
    static let LOGIN_TOKEN = "loginToken"
    static let IS_LOGIN = "isLogin"
    static let USER = "User"
    static let USER_ID = "userId"
    static let USER_TYPE = "userType"
    static let FCM_KEY = "fcmKey"
    static let USER_NAME = "userName"
    static let USER_IMAGE = "userImage"
    static let USER_EMAIL = "userEmail"
}

//MARK:- Logout User
func logoutUser()
{
    sideMenuViewController.hideLeftViewAnimated()
    UserDefaults.standard.set(false, forKey: USER_DEFAULTS_KEYS.IS_LOGIN)
    flushUserDefaults()
    clearImageCache()
    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SIDE_MENU"), object: nil, userInfo: ["sideMeneKey" : false])
    NotificationCenter.default.removeObserver(NSNotification.Name(rawValue: "SIDE_MENU"))
    (sideMenuViewController.rootViewController as! UINavigationController).pushViewController(UIStoryboard.loginViewController(), animated: false)
}
//MARK:- Remove User Defaults

func flushUserDefaults()
{
    UserDefaults.standard.removeObject(forKey: USER_DEFAULTS_KEYS.IS_LOGIN)
    UserDefaults.standard.removeObject(forKey: USER_DEFAULTS_KEYS.LOGIN_TOKEN)
}
//MARK:- Initialise App

func initialiseAppWithController(_ controller : UIViewController)
{
    let navigationController = UINavigationController(rootViewController: controller)
    navigationController.isNavigationBarHidden = true
    let sideMenuController = LGSideMenuController(rootViewController: navigationController, leftViewController:UIStoryboard.sideMenuViewController(), rightViewController: nil)
    sideMenuController.leftViewWidth = 250.0
    sideMenuController.rootViewLayerShadowColor = .black
    sideMenuController.leftViewPresentationStyle = .slideBelow
    sideMenuController.isRightViewSwipeGestureEnabled = false
    sideMenuController.isLeftViewSwipeGestureEnabled = false
    appDelegateInstance.window?.rootViewController = sideMenuController
}

//MARK:- Alert Methods
func showNoDataFoundAlert()
{
    UIAlertController.showInfoAlertWithTitle("", message: kNoDataFoundAlertString , buttonTitle: "Okay")
}

func showLostInternetConnectivityAlert()
{
    UIAlertController.showInfoAlertWithTitle("Uh Oh!", message: kLostInternetConnectivityAlertString , buttonTitle: "Okay")
}

func showNonNumericInputErrorAlert(_ fieldName : String)
{
    UIAlertController.showInfoAlertWithTitle("Error", message: String(format:"The %@ can only be numeric.",fieldName), buttonTitle: "Okay")
}

func showPasswordLengthAlert()
{
    UIAlertController.showInfoAlertWithTitle("Error", message: kPasswordLengthAlertString, buttonTitle: "Okay")
}

func showPasswordWhiteSpaceAlert()
{
    UIAlertController.showInfoAlertWithTitle("Error", message: kPasswordWhiteSpaceAlertString, buttonTitle: "Okay")
}

func showPasswordUnEqualAlert()
{
    UIAlertController.showInfoAlertWithTitle("Error", message: kUnequalPasswordsAlertString, buttonTitle: "Okay")
}

func showPasswordEqualAlert() {
    UIAlertController.showInfoAlertWithTitle("Error", message: kEqualPasswordsAlertString, buttonTitle: "Okay")
}

func showInvalidInputAlert(_ fieldName : String)
{
    UIAlertController.showInfoAlertWithTitle("Error", message: String(format:"Please enter a valid %@.",fieldName), buttonTitle: "Okay")
}

func showMessageLengthAlert()
{
    UIAlertController.showInfoAlertWithTitle("Error", message: kMesssageLengthAlertString , buttonTitle: "Okay")
}

func showSignUpCharacterCaseAlert()
{
    UIAlertController.showInfoAlertWithTitle("Error", message: kSignUpCaseAlertString , buttonTitle: "Okay")
}

//MARK:- MBProgressHUD Methods

func showProgressOnView(_ view:UIView)
{
    let loadingNotification = MBProgressHUD.showAdded(to: view, animated: true)
    loadingNotification.mode = MBProgressHUDMode.indeterminate
    loadingNotification.label.text = "Loading.."
}

func hideProgressOnView(_ view:UIView)
{
    MBProgressHUD.hide(for: view, animated: true)
}

func hideAllProgressOnView(_ view:UIView)
{
    MBProgressHUD.hideAllHUDs(for: view, animated: true)
}
//MARK:- Clear SDWebImage Cache

func clearImageCache()
{
    SDImageCache.shared.clearDisk()
    SDImageCache.shared.clearMemory()
}


//MARK:- Fetch Device Width

func fetchDeviceWidth() -> CGFloat {
    if IS_IPHONE_5 {
        return 320
    } else if IS_IPHONE_6 {
        return 375
    } else if IS_IPHONE_6P{
        return 414
    }else if IS_IPAD_Mini {
        return 768
    } else if IS_IPAD_Pro {
        return 834.0
    }
    else if IS_IPAD_Pro12 {
        return 760
    }
    else {
        return 1024
    }
}
//MARK:- Fetch Device Height

func fetchDeviceHeight() -> CGFloat {
    if IS_IPHONE_5 {
        return 568
    } else if IS_IPHONE_6 {
        return 667
    } else if IS_IPHONE_6P {
        return 736
    } else if IS_IPAD_Mini {
        return 1024
    } else if IS_IPAD_Pro  {
        return 1112
    } else if IS_IPAD_Pro12  {
        return 1366
    }else {
        return 1366
    }
    
}

public func disableEditinginTextFieldWithTagArr(tagList:Array<Int>,targetView:UIView)
{
    for index in tagList
    {  
        let txtField =  targetView.viewWithTag(index) as! UITextField
        txtField.isEnabled = false
    }
}

//MARK:-document directory realted method
public func getDirectoryPath() -> String {
    let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    let documentsDirectory = paths[0]
    return documentsDirectory
}

public func saveImageDocumentDirectory(usedImage:UIImage, nameStr:String) {
    let fileManager = FileManager.default
    let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(nameStr)
    let imageData = usedImage.jpegData(compressionQuality: 0.7)
    fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
}
