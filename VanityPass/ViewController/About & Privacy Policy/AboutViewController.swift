//
//  AboutViewController.swift
//  VanityPass
//
//  Created by chawtech solutions on 4/2/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController, UIWebViewDelegate {
    @IBOutlet weak var customNavigationBar: CustomNavigationBarForDrawer!
    @IBOutlet weak var webView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        customNavigationBar.titleLabel.text = "About"
        webView.delegate = self
        webView.scrollView.bounces = false
        self.loadUrlOnWebView()
    }
    
    func loadUrlOnWebView() {
        showProgressOnView(self.view)
        if let url = URL(string: BASE_URL + PROJECT_URL.ABOUT_API) {
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
