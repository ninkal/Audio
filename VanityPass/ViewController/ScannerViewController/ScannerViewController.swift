//  ScannerViewController.swift
//  VanityPass
//
//  Created by Amit on 14/03/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import AVFoundation
import UIKit

class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    @IBOutlet weak var customNavigationBar: CustomNavigationBar!
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customNavigationBar.titleLabel.text = "Scan Offer"
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        }
        catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        }
        else {
            failed()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        }
        else {
            failed()
            return
        }
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = CGRect.init(x: 0, y: 74, width: self.view.frame.size.width, height: self.view.frame.size.height - 74)
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        captureSession.startRunning()
    }
    
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }
        dismiss(animated: true)
    }
    
    func found(code: String) {
        let data = code.data(using: .utf8)!
        do {
            if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? Dictionary<String,Any> {
                print(jsonArray)
                let eventDict = jsonArray["event"] as! NSDictionary
                let offerDict = jsonArray["offer"] as! NSDictionary
                let ticketDict = jsonArray["ticket"] as! NSDictionary
                let userDict = jsonArray["user"] as! NSDictionary
                self.scanTicketApi(event: eventDict, offer: offerDict, ticket: ticketDict, user: userDict)
            }
            else {
                UIAlertController.showInfoAlertWithTitle("Alert!", message: "Sorry, QRCode is not Scan.", buttonTitle: "Okay")
            }
        }
        catch let error as NSError {
            print(error)
            UIAlertController.showInfoAlertWithTitle("Alert!", message: "Sorry, QRCode is not Valid.", buttonTitle: "Okay")
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    func scanTicketApi(event:NSDictionary, offer:NSDictionary, ticket:NSDictionary, user: NSDictionary) {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(self.view)
            let param1:[String:String] = [
                "id": "\(ticket["id"]!)",
                "event_id":"\(ticket["event_id"]!)",
                "offer_id": "\(ticket["event_offer_id"]!)",
                "user_id" : "\(user["id"]!)"
            ]
            print(param1)
            ServerClass.sharedInstance.postRequestWithUrlParameters(param1, path: BASE_URL + PROJECT_URL.SCAN_TICKET_PARTNER_API, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(self.view)
                let success = json["success"].stringValue
                if success  == "true"  {
                    let viewController = UIStoryboard.modelInfoViewController()
                    viewController.eventDict = event
                    viewController.offerDict = offer
                    viewController.ticketDict = ticket
                    viewController.userDict = user
                    self.navigationController?.pushViewController(viewController, animated: true)
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
