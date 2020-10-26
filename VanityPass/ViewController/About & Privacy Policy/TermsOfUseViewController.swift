//
//  TermsOfUseViewController.swift
//  VanityPass
//
//  Created by Chawtech on 09/04/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit

class TermsOfUseViewController: UIViewController, UIWebViewDelegate {
    @IBOutlet weak var customNavigationBar: CustomNavigationBar!
    @IBOutlet weak var webView: UIWebView!
    var titleStr: String!
    var urlStr: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        customNavigationBar.titleLabel.text = titleStr
        webView.delegate = self
        webView.scrollView.bounces = false
        self.loadUrlOnWebView()
    }
    
    func loadUrlOnWebView() {
        showProgressOnView(self.view)
        if let url = URL(string: BASE_URL + urlStr) {
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
