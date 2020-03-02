//
//  WebViewController.swift
//  NewsReader
//
//  Created by Internship on 27/02/2020.
//  Copyright © 2020 Internship. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {

    private var webView: WKWebView!
    private var url: URL?
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let url = url {
            webView.load(URLRequest(url: url))
            webView.allowsBackForwardNavigationGestures = true
        }
        
    }
    
    func setWebViewURL(_ url: String){
        self.url = URL(string: url)
    }

}
