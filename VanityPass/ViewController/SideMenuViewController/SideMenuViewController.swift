//
//  SideMenuViewController.swift
//  TeamLink
//
//  Created by chawtech solutions on 3/01/18.
//  Copyright © 2018 chawtech solutions. All rights reserved.
//

import UIKit
import SDWebImage
import LGSideMenuController

class SideMenuViewController: UIViewController {
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var profileOptionsTableView: UITableView!
    @IBOutlet weak var logoutBtn: UIButton!
    
    var optionsNameArray : [String] = []
    var optionsImagesArray : [UIImage] = []
    var optionsWhiteImagesArray : [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSideMenuData(profileBool:true)
        
        self.profileOptionsTableView.rowHeight = 45
        profileOptionsTableView.register(UINib(nibName: "SideMenuTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "SideMenuTableViewCell")
        //        let cell:SideMenuTableViewCell = profileOptionsTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! SideMenuTableViewCell
        //        self.profileOptionsTableView.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: UITableView.ScrollPosition.none)
        //        cell.contentView.backgroundColor = UIColor.init(red: 213/255, green: 4/255, blue: 73/255, alpha: 1.0)
        //        cell.titleLabel.textColor = UIColor.white
        //        cell.iconImageView.image = optionsWhiteImagesArray[0]
        
        NotificationCenter.default.addObserver(self, selector: #selector(isLogin(notification:)), name: NSNotification.Name(rawValue: "SIDE_MENU"), object: nil)
    }
    
    func setSideMenuData(profileBool: Bool) {
        if UserDefaults.standard.bool(forKey: USER_DEFAULTS_KEYS.IS_LOGIN) != true {
            optionsNameArray = ["Login", "Contact Us"," Privacy policy", "About", "Terms of use"]
            optionsImagesArray = [#imageLiteral(resourceName: "login"),#imageLiteral(resourceName: "contact-us"),#imageLiteral(resourceName: "privacy-policy"),#imageLiteral(resourceName: "about"),#imageLiteral(resourceName: "terms_icon_black")]
            optionsWhiteImagesArray = [#imageLiteral(resourceName: "login_white"),#imageLiteral(resourceName: "contact-us_white"),#imageLiteral(resourceName: "privacy_white"),#imageLiteral(resourceName: "about_white"),#imageLiteral(resourceName: "terms_icon_white")]
            self.profileImageView.image = #imageLiteral(resourceName: "afterl-login-logo")
            self.profileImageView.layer.cornerRadius = 0
            self.profileImageView.layer.masksToBounds = false
            self.nameLbl.text = ""
            self.logoutBtn.isHidden = true
        }
        else {
            self.profileImageView.layer.cornerRadius = 100/2
            self.profileImageView.layer.masksToBounds = true
            self.logoutBtn.isHidden = false
            if UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.USER_TYPE) as! String == "model" {
                optionsNameArray = ["Home", "Profile", "Reserved offers", "Change Password", "Contact Us", "Privacy policy", "About", "Terms of use"]
                optionsImagesArray = [#imageLiteral(resourceName: "hometown"),#imageLiteral(resourceName: "profile_icon"),#imageLiteral(resourceName: "reserved_event"),#imageLiteral(resourceName: "pw-change"),#imageLiteral(resourceName: "contact-us"),#imageLiteral(resourceName: "privacy-policy"),#imageLiteral(resourceName: "about"),#imageLiteral(resourceName: "terms_icon_black")]
                optionsWhiteImagesArray = [#imageLiteral(resourceName: "home"),#imageLiteral(resourceName: "profile_icon_white"),#imageLiteral(resourceName: "reserved_event_white"),#imageLiteral(resourceName: "pw_change_white"),#imageLiteral(resourceName: "contact-us_white"),#imageLiteral(resourceName: "privacy_white"),#imageLiteral(resourceName: "about_white"),#imageLiteral(resourceName: "terms_icon_white")]
            }
            else {
                optionsNameArray = ["Home", "Add Venue", "Profile","Change Password", "Contact Us", "Privacy policy", "About", "Terms of use"]
                optionsImagesArray = [#imageLiteral(resourceName: "hometown"),#imageLiteral(resourceName: "add_event"),#imageLiteral(resourceName: "profile_icon"),#imageLiteral(resourceName: "pw-change"),#imageLiteral(resourceName: "contact-us"),#imageLiteral(resourceName: "privacy-policy"),#imageLiteral(resourceName: "about"),#imageLiteral(resourceName: "terms_icon_black")]
                optionsWhiteImagesArray = [#imageLiteral(resourceName: "home"),#imageLiteral(resourceName: "add_event_white"),#imageLiteral(resourceName: "profile_icon_white"),#imageLiteral(resourceName: "pw_change_white"),#imageLiteral(resourceName: "contact-us_white"),#imageLiteral(resourceName: "privacy_white"),#imageLiteral(resourceName: "about_white"),#imageLiteral(resourceName: "terms_icon_white")]
            }
            
            if UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.USER_NAME) as? String != nil {
                self.nameLbl.text = UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.USER_NAME) as? String
            }
            else {
                self.nameLbl.text = ""
            }
            if UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.USER_IMAGE) as? String != nil {
                let imageNameStr : String = UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.USER_IMAGE) as! String
                self.profileImageView.sd_setImage(with: URL.init(string: IMAGE_URL + "users/" + imageNameStr), placeholderImage: #imageLiteral(resourceName: "userImage"))
            }
            else {
                self.profileImageView.image = #imageLiteral(resourceName: "userImage")
            }
        }
//        if UserDefaults.standard.bool(forKey: USER_DEFAULTS_KEYS.IS_LOGIN) == true {
//            if profileBool == true {
//                profileOptionsTableView.reloadData {
//                    self.profileOptionsTableView.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .top)
//                    self.profileOptionsTableView.delegate?.tableView!(self.profileOptionsTableView, didSelectRowAt: IndexPath(row: 0, section: 0))
//                }
//            }
//            else {
//                if UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.USER_TYPE) as! String == "model" {
//                    profileOptionsTableView.reloadData {
//                        self.profileOptionsTableView.selectRow(at: IndexPath(row: 1, section: 0), animated: true, scrollPosition: .top)
//                        self.profileOptionsTableView.delegate?.tableView!(self.profileOptionsTableView, didSelectRowAt: IndexPath(row: 1, section: 0))
//                    }
//                }
//                else {
//                    profileOptionsTableView.reloadData {
//                        self.profileOptionsTableView.selectRow(at: IndexPath(row: 2, section: 0), animated: true, scrollPosition: .top)
//                        self.profileOptionsTableView.delegate?.tableView!(self.profileOptionsTableView, didSelectRowAt: IndexPath(row: 2, section: 0))
//                    }
//                }
//            }
//        }
//        else {
//            profileOptionsTableView.reloadData {
//                self.profileOptionsTableView.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .top)
//                self.profileOptionsTableView.delegate?.tableView!(self.profileOptionsTableView, didSelectRowAt: IndexPath(row: 0, section: 0))
//            }
//        }
        profileOptionsTableView.reloadData()
    }
    
    @objc private func isLogin(notification: NSNotification) {
        let bool : Bool = (notification.userInfo!["sideMeneKey"] as? Bool)!
        setSideMenuData(profileBool: bool)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String {
            if let buildVersion = Bundle.main.infoDictionary?["CFBundleVersion"]  as? String {
                let versionStr = "Version - \(appVersion)(\(buildVersion))"
                self.versionLabel.text = versionStr
            }
        }
    }
    
    @IBAction func logoutBtnTap(_ sender: Any) {
        let alert = UIAlertController(title: "Are you sure you want to Sign Out?", message: nil, preferredStyle: .alert)
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: { (action) in })
        let yesAction = UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            //                let cell:SideMenuTableViewCell = self.profileOptionsTableView.cellForRow(at: IndexPath(row: 6, section: 0)) as! SideMenuTableViewCell
            ////                self.profileOptionsTableView.deselectRow(at: IndexPath(row: 0, section: 0), animated: true)
            //                cell.contentView.backgroundColor = UIColor.clear
            //                cell.titleLabel.textColor = UIColor.black
            logoutUser()
        })
        alert.addAction(noAction)
        alert.addAction(yesAction)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension SideMenuViewController : UITableViewDataSource , UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return optionsNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuTableViewCell") as! SideMenuTableViewCell
        cell.iconImageView.image = optionsImagesArray[indexPath.row]
        cell.titleLabel.text = optionsNameArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell:SideMenuTableViewCell = tableView.cellForRow(at: indexPath) as! SideMenuTableViewCell
//        cell.contentView.backgroundColor = UIColor.init(red: 213/255, green: 4/255, blue: 73/255, alpha: 1.0)
//        cell.titleLabel.textColor = UIColor.white
//        cell.iconImageView.image = optionsWhiteImagesArray[indexPath.row]
        
        let navController = sideMenuViewController.rootViewController as! UINavigationController
        switch indexPath.row {
        case 0: sideMenuViewController.hideLeftViewAnimated()
        if UserDefaults.standard.bool(forKey: USER_DEFAULTS_KEYS.IS_LOGIN) != true {
            if !(navController.visibleViewController is LoginViewController) {
                navController.pushViewController(UIStoryboard.loginViewController(), animated: false)
            }
        }
        else {
            if UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.USER_TYPE) as! String == "model" {
                if !(navController.visibleViewController is ModelHomeViewController) {
                    navController.pushViewController(UIStoryboard.modelHomeViewController(), animated: false)
                }
            }
            else {
                if !(navController.visibleViewController is PartnerHomeViewController) {
                    navController.pushViewController(UIStoryboard.partnerHomeViewController(), animated: false)
                }
            }
        }
            break
        case 1: sideMenuViewController.hideLeftViewAnimated()
        if UserDefaults.standard.bool(forKey: USER_DEFAULTS_KEYS.IS_LOGIN) != true {
            if !(navController.visibleViewController is ContactUsViewController) {
                navController.pushViewController(UIStoryboard.contactUsViewController(), animated: false)
            }
        }
        else {
            if UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.USER_TYPE) as! String == "model" {
                if !(navController.visibleViewController is ProfileViewController) {
                    navController.pushViewController(UIStoryboard.profileViewController(), animated: false)
                }
            }
            else {
                if !(navController.visibleViewController is AddEventViewController) {
                    navController.pushViewController(UIStoryboard.addEventViewController(), animated: false)
                }
            }
        }
            break
        case 2: sideMenuViewController.hideLeftViewAnimated()
        if UserDefaults.standard.bool(forKey: USER_DEFAULTS_KEYS.IS_LOGIN) != true {
            if !(navController.visibleViewController is PrivacyPolicyViewController) {
                navController.pushViewController(UIStoryboard.privacyPolicyViewController(), animated: false)
            }
        }
        else {
            if UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.USER_TYPE) as! String == "model" {
                if !(navController.visibleViewController is MyReserveEventViewController) {
                    navController.pushViewController(UIStoryboard.myReserveEventViewController(), animated: false)
                }
            }
            else {
                if !(navController.visibleViewController is PartnerProfileViewController) {
                    navController.pushViewController(UIStoryboard.partnerProfileViewController(), animated: false)
                }
            }
        }
            break
        case 3: sideMenuViewController.hideLeftViewAnimated()
        if UserDefaults.standard.bool(forKey: USER_DEFAULTS_KEYS.IS_LOGIN) != true {
            if !(navController.visibleViewController is AboutViewController) {
                navController.pushViewController(UIStoryboard.aboutViewController(), animated: false)
            }
        }
        else {
            if !(navController.visibleViewController is ChangePasswordViewController) {
                navController.pushViewController(UIStoryboard.changePasswordViewController(), animated: false)
            }
        }
            break
        case 4: sideMenuViewController.hideLeftViewAnimated()
        if UserDefaults.standard.bool(forKey: USER_DEFAULTS_KEYS.IS_LOGIN) != true {
            if !(navController.visibleViewController is TermsOfUseViewController) {
                let viewController = UIStoryboard.termsOfUseViewController()
                viewController.titleStr = "Terms of use"
                viewController.urlStr = PROJECT_URL.TERMS_OF_USE_API
                navController.pushViewController(viewController, animated: false)
            }
        }
        else {
            if !(navController.visibleViewController is ContactUsViewController) {
                navController.pushViewController(UIStoryboard.contactUsViewController(), animated: false)
            }
        }
            break
        case 5: sideMenuViewController.hideLeftViewAnimated()
        if !(navController.visibleViewController is PrivacyPolicyViewController) {
            navController.pushViewController(UIStoryboard.privacyPolicyViewController(), animated: false)
        }
            break
        case 6: sideMenuViewController.hideLeftViewAnimated()
        if !(navController.visibleViewController is AboutViewController) {
            navController.pushViewController(UIStoryboard.aboutViewController(), animated: false)
        }
            break
        case 7: sideMenuViewController.hideLeftViewAnimated()
        if !(navController.visibleViewController is TermsOfUseViewController) {
            let viewController = UIStoryboard.termsOfUseViewController()
            viewController.titleStr = "Terms of use"
            viewController.urlStr = PROJECT_URL.TERMS_OF_USE_API
            navController.pushViewController(viewController, animated: false)
            }
            break
        default: break
        }
    }
    
//    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        let cell:SideMenuTableViewCell = tableView.cellForRow(at: indexPath) as! SideMenuTableViewCell
//        cell.contentView.backgroundColor = UIColor.clear
//        cell.titleLabel.textColor = UIColor.black
//        cell.iconImageView.image = optionsImagesArray[indexPath.row]
//    }
//
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
}

extension UITableView {
    func reloadData(completion: @escaping ()->()) {
        UIView.animate(withDuration: 0, animations: { self.reloadData() })
        { _ in completion() }
    }
}

