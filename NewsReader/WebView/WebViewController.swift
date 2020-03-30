//
//  WebViewController.swift
//  NewsReader
//
//  Created by Internship on 27/02/2020.
//  Copyright © 2020 Internship. All rights reserved.
//

import UIKit
import WebKit
import RxSwift

class WebViewController: UIViewController, WKNavigationDelegate {

    //MARK: Properties
    private var webView: WKWebView!
    
    var webViewViewModel: WebViewViewModel!
    
    private let bag = DisposeBag()
    
    weak var parentCoordinator: WebViewCoordinator?
    
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setObserver()
        
        webViewViewModel.loadNews()
        
    }

    //MARK: Private Methods
    private func setObserver() {
        webViewViewModel.loadArticle.subscribe(onNext: { [weak self] url in
            self?.webView.load(URLRequest(url: url))
            self?.webView.allowsBackForwardNavigationGestures = true
        }).disposed(by: bag)
    }
}
