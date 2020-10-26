//
//  AboutAndPrivacyPolicyViewController.swift
//  VanityPass
//
//  Created by Demo on 05/03/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit

class PrivacyPolicyViewController: UIViewController, UIWebViewDelegate {
    @IBOutlet weak var customNavigationBar: CustomNavigationBarForDrawer!
    @IBOutlet weak var webView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()  
        customNavigationBar.titleLabel.text = "Privacy policy"
        webView.delegate = self
        webView.scrollView.bounces = false
        self.loadUrlOnWebView()
    }
    
    func loadUrlOnWebView() {
        showProgressOnView(self.view)
        if let url = URL(string: BASE_URL + PROJECT_URL.PRIVACY_API) {
            webView.loadRequest(URLRequest(url: url))
        }
    }
    
    public func webViewDidStartLoad(_ webView: UIWebView) {
        //showProgressOnView(self.view)
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        DispatchQueue.main.async {
            hideAllProgressOnView(self.view)
        }
        let myalert = UIAlertController(title: "", message: "Something went wrong,please try again", preferredStyle: UIAlertController.Style.alert)
        myalert.addAction(UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction!) in
            self.loadUrlOnWebView()
        })
        self.present(myalert, animated: true)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        DispatchQueue.main.async {
            hideAllProgressOnView(self.view)
        }
    }
}
