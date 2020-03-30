//
//  SingleArticleCoordinator.swift
//  NewsReader
//
//  Created by Internship on 30/03/2020.
//  Copyright © 2020 Internship. All rights reserved.
//

import UIKit

class SingleArticleCoordinator: NSObject, Coordinator, UINavigationControllerDelegate, WebView {
    weak var parentCoordinator: SingleArticle?
    var childCoordinators: [Coordinator] = []
    var presenter: UINavigationController
    
    let articles: [News]
    let index: Int
    
    init(presenter: UINavigationController, articles: [News], index: Int) {
        self.presenter = presenter
        self.articles = articles
        self.index = index
    }
    
    func start() {
        presenter.delegate = self
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let articleCollectionViewController = ArticleCollectionViewController(collectionViewLayout: layout)
        articleCollectionViewController.parentCoordinator = self

        let singleArticleViewModel = SingleArticleViewModel(articles: articles, index: index)

        articleCollectionViewController.singleArticleViewModel = singleArticleViewModel

        presenter.pushViewController(articleCollectionViewController, animated: true)
    }
    
    func openInBrowser(articleUrl: String) {
        let child = WebViewCoordinator(presenter: presenter, articleUrl: articleUrl)
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.start()
    }
    
    func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }

    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        // Read the view controller we’re moving from.
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
            return
        }

        // Check whether our view controller array already contains that view controller. If it does it means we’re pushing a different view controller on top rather than popping it, so exit.
        if navigationController.viewControllers.contains(fromViewController) {
            return
        }

        // We’re still here – it means we’re popping the view controller, so we can check whether it’s a single article view controller
        if let webViewController = fromViewController as? WebViewController {
            // We're popping a buy view controller; end its coordinator
            childDidFinish(webViewController.parentCoordinator)
        }
    }
}
