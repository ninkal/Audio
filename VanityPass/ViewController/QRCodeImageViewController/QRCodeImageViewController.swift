//
//  WebViewController.swift
//  VanityPass
//
//  Created by Chawtech on 04/04/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit

class QRCodeImageViewController: UIViewController, UIWebViewDelegate {
    @IBOutlet weak var CustomNavigationBar: CustomNavigationBar!
    @IBOutlet weak var barCodeImageView: UIImageView!
    var barCodePngUrlStr :String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CustomNavigationBar.titleLabel.text = "QR Code"
        self.barCodeImageView!.sd_setImage(with: URL(string: IMAGE_URL + "qrcodes/" + barCodePngUrlStr),  placeholderImage: #imageLiteral(resourceName: "placeholder"))
    }
}
