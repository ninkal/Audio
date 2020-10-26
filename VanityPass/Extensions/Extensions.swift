//
//  Extensions.swift
//  OHLEsport
//
//  Created by Tushar Agarwal on 27/10/17.
//  Copyright © 2017 Tushar Agarwal. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

extension UIStoryboard {
    class func mainStoryBoard() -> UIStoryboard{
        return UIStoryboard(name: "Main", bundle: Bundle.main)
    }
    class func loginViewController() -> LoginViewController {
        return mainStoryBoard().instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
    }
    class func changePasswordViewController() -> ChangePasswordViewController {
        return mainStoryBoard().instantiateViewController(withIdentifier: "ChangePasswordViewController") as! ChangePasswordViewController
    }
    class func sideMenuViewController() -> SideMenuViewController {
        return mainStoryBoard().instantiateViewController(withIdentifier: "SideMenuViewController") as! SideMenuViewController
    }
    class func registerOptionViewController1() -> RegisterOptionViewController {
        return mainStoryBoard().instantiateViewController(withIdentifier: "RegisterOptionViewController") as! RegisterOptionViewController
    }
    class func registerFirstViewController() -> RegistrationFirstViewController {
        return mainStoryBoard().instantiateViewController(withIdentifier: "RegistrationFirstViewController") as! RegistrationFirstViewController
    }
    class func registerSecondViewController() -> RegistrationSecondViewController {
        return mainStoryBoard().instantiateViewController(withIdentifier: "RegistrationSecondViewController") as! RegistrationSecondViewController
    }
    class func registerPartnerFirstViewController() -> RegisterPartnerFirstViewController {
        return mainStoryBoard().instantiateViewController(withIdentifier: "RegisterPartnerFirstViewController") as! RegisterPartnerFirstViewController
    }
    class func forgotPasswordViewController() -> ForgotPasswordViewController {
        return mainStoryBoard().instantiateViewController(withIdentifier: "ForgotPasswordViewController") as! ForgotPasswordViewController
    }
    class func modelHomeViewController() -> ModelHomeViewController {
        return mainStoryBoard().instantiateViewController(withIdentifier: "ModelHomeViewController") as! ModelHomeViewController
    }
    class func partnerHomeViewController() -> PartnerHomeViewController {
        return mainStoryBoard().instantiateViewController(withIdentifier: "PartnerHomeViewController") as! PartnerHomeViewController
    }
    class func addEventViewController() -> AddEventViewController {
        return mainStoryBoard().instantiateViewController(withIdentifier: "AddEventViewController") as! AddEventViewController
    }
    class func scannerViewController() -> ScannerViewController {
        return mainStoryBoard().instantiateViewController(withIdentifier: "ScannerViewController") as! ScannerViewController
    }
    class func eventDetailsViewController() -> EventDetailsViewController {
        return mainStoryBoard().instantiateViewController(withIdentifier: "EventDetailsViewController") as! EventDetailsViewController
    }
    class func modelInfoViewController() -> ModelInfoViewController {
        return mainStoryBoard().instantiateViewController(withIdentifier: "ModelInfoViewController") as! ModelInfoViewController
    }
    class func offerDetailsViewController() -> OfferDetailsViewController {
        return mainStoryBoard().instantiateViewController(withIdentifier: "OfferDetailsViewController") as! OfferDetailsViewController
    }
    class func eventBarCodeViewController() -> EventBarCodeViewController {
        return mainStoryBoard().instantiateViewController(withIdentifier: "EventBarCodeViewController") as! EventBarCodeViewController
    }
    class func venueViewController() -> VenueViewController {
        return mainStoryBoard().instantiateViewController(withIdentifier: "VenueViewController") as! VenueViewController
    }
    class func contactUsViewController() -> ContactUsViewController {
        return mainStoryBoard().instantiateViewController(withIdentifier: "ContactUsViewController") as! ContactUsViewController
    }
    class func supportViewController() -> SupportViewController {
        return mainStoryBoard().instantiateViewController(withIdentifier: "SupportViewController") as! SupportViewController
    }
    class func privacyPolicyViewController() -> PrivacyPolicyViewController {
        return mainStoryBoard().instantiateViewController(withIdentifier: "PrivacyPolicyViewController") as! PrivacyPolicyViewController
    }
    class func aboutViewController() -> AboutViewController {
        return mainStoryBoard().instantiateViewController(withIdentifier: "AboutViewController") as! AboutViewController
    }
    class func termsOfUseViewController() -> TermsOfUseViewController {
        return mainStoryBoard().instantiateViewController(withIdentifier: "TermsOfUseViewController") as! TermsOfUseViewController
    }
    class func myReserveEventViewController() -> MyReserveEventViewController {
        return mainStoryBoard().instantiateViewController(withIdentifier: "MyReserveEventViewController") as! MyReserveEventViewController
    }
    class func profileViewController() -> ProfileViewController {
        return mainStoryBoard().instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
    }
    class func partnerProfileViewController() -> PartnerProfileViewController {
        return mainStoryBoard().instantiateViewController(withIdentifier: "PartnerProfileViewController") as! PartnerProfileViewController
    }
    class func qrCodeImageViewController() -> QRCodeImageViewController {
      return mainStoryBoard().instantiateViewController(withIdentifier: "QRCodeImageViewController") as! QRCodeImageViewController
    }
}
  
extension UIView{
    
    @IBInspectable var borderColor:UIColor{
        set{
            self.layer.borderColor = (newValue as UIColor).cgColor
        }
        get{
            let color  = self.layer.borderColor
            return UIColor(cgColor: color!)
        }
    }
    
    @IBInspectable var borderWidth:CGFloat{
        set{
            self.layer.borderWidth = newValue
        }
        get{
            return self.layer.borderWidth
        }
    }
    
    @IBInspectable var cornerRadius:CGFloat{
        set{
            self.layer.cornerRadius = newValue
        }
        get{
            return self.layer.cornerRadius
        }
    }
    
    @IBInspectable var maskToBounds:Bool{
        set{
            self.layer.masksToBounds = newValue
        }
        get{
            return self.layer.masksToBounds
        }
    }
}

extension UIAlertController {
    class func showInfoAlertWithTitle(_ title: String?, message: String?, buttonTitle: String, viewController: UIViewController? = nil){
        DispatchQueue.main.async(execute: {
            let alertController = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
            let okayAction = UIAlertAction.init(title: buttonTitle, style: .default, handler: { (okayAction) in
                if viewController != nil {
                    viewController?.dismiss(animated: true, completion: nil)
                }
                else {
                    UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: nil)
                }
            })
            alertController.addAction(okayAction)
            if viewController != nil {
                viewController?.present(alertController, animated: true, completion: nil)
            }
            else {
                UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
            }
        })
    }
}

extension UITextField{
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
}

@IBDesignable
extension UITextField {
    @IBInspectable var paddingLeftCustom: CGFloat {
        get {
            return leftView!.frame.size.width
        }
        set {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: frame.size.height))
            leftView = paddingView
            leftViewMode = .always
        }
    }
    
    @IBInspectable var paddingRightCustom: CGFloat {
        get {
            return rightView!.frame.size.width
        }
        set {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: frame.size.height))
            rightView = paddingView
            rightViewMode = .always
        }
    }
}

extension String {
    var containsEmoji: Bool {
        for scalar in unicodeScalars {
            switch scalar.value {
            case 0x1F600...0x1F64F, // Emoticons
            0x1F300...0x1F5FF, // Misc Symbols and Pictographs
            0x1F680...0x1F6FF, // Transport and Map
            0x2600...0x26FF,   // Misc symbols
            0x2700...0x27BF,   // Dingbats
            0xFE00...0xFE0F:   // Variation Selectors
                return true
            default:
                continue
            }
        }
        return false
    }
    
    func containsOnlyNumbers(_ string : String) -> Bool {
        let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
        let compSepByCharInSet = (string as NSString).components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        return string == numberFiltered
    }
    
    init(htmlEncodedString: String) {
        self.init()
        guard let encodedData = htmlEncodedString.data(using: .utf8) else {
            self = htmlEncodedString
            return
        }
        
        let attributedOptions: [NSAttributedString.DocumentReadingOptionKey : Any] = [
            NSAttributedString.DocumentReadingOptionKey(rawValue: NSAttributedString.DocumentAttributeKey.documentType.rawValue): NSAttributedString.DocumentType.html,
            NSAttributedString.DocumentReadingOptionKey(rawValue: NSAttributedString.DocumentAttributeKey.characterEncoding.rawValue): String.Encoding.utf8.rawValue
        ]
        do {
            let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
            self = attributedString.string
        }
        catch {
            self = htmlEncodedString
        }
    }
    
    func slice(from: String, to: String) -> String? {
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }
}

extension Date {
    func dayNumber() -> Int? {
        return Calendar.current.dateComponents([.day], from: self).day
    }
    
    func monthName() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.string(from: self).capitalized
    }
    
    func year() -> Int? {
        return Calendar.current.dateComponents([.year], from: self).year
    }
    
    func weekNumber() -> Int? {
        return Calendar.current.ordinality(of: .weekday, in: .year, for: self)!
    }
    
    func dayNumberOYear() -> Int? {
        return Calendar.current.ordinality(of: .day, in: .year, for: self)!
    }
    
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).localizedUppercase
    }
    
    func monthNumber() -> Int? {
        return Calendar.current.dateComponents([.month], from: self).month
    }
    
    var startOfWeek: Date {
        let date = Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))!
        let dslTimeOffset = NSTimeZone.local.daylightSavingTimeOffset(for: date)
        return date.addingTimeInterval(dslTimeOffset)
    }
    
    var endOfWeek: Date {
        return Calendar.current.date(byAdding: .second, value: 604799, to: self.startOfWeek)!
    }
    
    var startOfMonth: Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    var endOfMonth: Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth)!
    }
    
    func toString( dateFormat format  : String ) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)  
    }
}

extension UIViewController {
    func getDayFromDate(dateString: String, dateFormat: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        let date = dateFormatter.date(from: dateString)
        
        let dateFormat = DateFormatter()
        dateFormat.dateFormat  = "EEEE"//"EE" to get short style
        return date != nil ? dateFormat.string(from: date!) : "" //"Sunday"
    }
    
    func getMonthFromDate(dateString: String, dateFormat: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        let date = dateFormatter.date(from: dateString)
        
        let dateFormat = DateFormatter()
        dateFormat.dateFormat  = "LLLL"//"EE" to get short style
        return date != nil ? dateFormat.string(from: date!) : "" //"January"
    }
    
    func getDateTimeFromTimeStamp(timeStamp:Double) -> String? {
        let date = NSDate(timeIntervalSince1970: timeStamp/1000)
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.locale = Locale(identifier: "en_US_POSIX")
        dayTimePeriodFormatter.dateFormat = "MM-dd-YYYY 'at' hh:mm:ss a"
        let dateString = dayTimePeriodFormatter.string(from: date as Date)
        return dateString
    }
}
extension UIViewController {
    func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        //image.draw(in: CGRectMake(0, 0, newSize.width, newSize.height))
        image.draw(in: CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: newSize.width, height: newSize.height))  )
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func maskRoundedImage(image: UIImage, radius: CGFloat) -> UIImage {
        let imageView: UIImageView = UIImageView(image: image)
        let layer = imageView.layer
        layer.masksToBounds = true
        layer.cornerRadius = radius
        UIGraphicsBeginImageContext(imageView.bounds.size)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let roundedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return roundedImage!
    }
}

extension UIImage {
    func fixOrientation() -> UIImage? {
        if imageOrientation == .up {
            return self
        }
        // We need to calculate the proper transformation to make the image upright.
        // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
        var transform: CGAffineTransform = .identity
        switch imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: .pi)
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: .pi/2)
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: size.height)
            transform = transform.rotated(by: -.pi/2)
        case .up, .upMirrored:
            break
        }
        switch imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .up, .down, .left, .right:
            break
        }
        let ctx = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: (cgImage?.bitsPerComponent)!, bytesPerRow: 0, space: (cgImage?.colorSpace)!, bitmapInfo: (cgImage?.bitmapInfo)!.rawValue)
        ctx?.concatenate(transform)
        switch imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            // Grr...
            ctx?.draw(cgImage!, in: CGRect(x: 0, y: 0, width: size.height, height: size.width))
        default:
            ctx?.draw(cgImage!, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        }
        // And now we just create a new UIImage from the drawing context
        let cgimg = ctx?.makeImage()
        let img = UIImage(cgImage: cgimg!)
        return img
    }
}
