//
//  WebViewCoordinator.swift
//  NewsReader
//
//  Created by Internship on 30/03/2020.
//  Copyright © 2020 Internship. All rights reserved.
//

import UIKit

class WebViewCoordinator: Coordinator {
    weak var parentCoordinator: CoordinatorDelegate?
    var childCoordinators: [Coordinator] = []
    var presenter: UINavigationController
    let controller: WebViewController
    let articleUrl: String
    
    init(presenter: UINavigationController, articleUrl: String) {
        self.presenter = presenter
        self.articleUrl = articleUrl
        
        let webViewController = WebViewController()
        let viewModel = WebViewViewModel(url: articleUrl)
        webViewController.webViewViewModel = viewModel
        self.controller = webViewController
    }
    
    func start() {
        controller.webViewViewModel.coordinatorDelegate = self
        presenter.pushViewController(controller, animated: true)
    }
}

extension WebViewCoordinator: ViewControllerDelegate {
    
    func viewControllerHasFinished() {
        childCoordinators.removeAll()
        parentCoordinator?.childDidFinish(child: self)
    }
}
