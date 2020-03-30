//
//  WebViewCoordinator.swift
//  NewsReader
//
//  Created by Internship on 30/03/2020.
//  Copyright © 2020 Internship. All rights reserved.
//

import UIKit

class WebViewCoordinator: Coordinator {
    weak var parentCoordinator: WebView?
    var childCoordinators: [Coordinator] = []
    var presenter: UINavigationController
    
    let articleUrl: String
    
    init(presenter: UINavigationController, articleUrl: String) {
        self.presenter = presenter
        self.articleUrl = articleUrl
    }
    
    func start() {
        let webViewController = WebViewController()
        let webViewViewModel = WebViewViewModel(url: articleUrl)
        webViewController.webViewViewModel = webViewViewModel
        webViewController.parentCoordinator = self
        presenter.pushViewController(webViewController, animated: true)
    }
}
