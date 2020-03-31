//
//  SingleArticleCoordinator.swift
//  NewsReader
//
//  Created by Internship on 30/03/2020.
//  Copyright © 2020 Internship. All rights reserved.
//

import UIKit

class SingleArticleCoordinator: Coordinator {
    weak var parentCoordinator: CoordinatorDelegate?
    var childCoordinators: [Coordinator] = []
    var presenter: UINavigationController
    let controller: ArticleCollectionViewController
    let articles: [News]
    let index: Int
    
    init(presenter: UINavigationController, articles: [News], index: Int) {
        self.presenter = presenter
        self.articles = articles
        self.index = index
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let articleCollectionController = ArticleCollectionViewController(collectionViewLayout: layout)
        let viewModel = SingleArticleViewModel(articles: articles, index: index)
        articleCollectionController.singleArticleViewModel = viewModel
        self.controller = articleCollectionController
    }
    
    func start() {
        controller.singleArticleViewModel.coordinatorDelegate = self
        presenter.pushViewController(controller, animated: true)
    }
}

extension SingleArticleCoordinator: WebViewDelegate {
    
    func openInBrowser(articleUrl: String) {
        let child = WebViewCoordinator(presenter: presenter, articleUrl: articleUrl)
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.start()
    }
}

extension SingleArticleCoordinator: CoordinatorDelegate {
    
    func childDidFinish(child: Coordinator) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
}

extension SingleArticleCoordinator: ViewControllerDelegate {
    
    func viewControllerHasFinished() {
        childCoordinators.removeAll()
        parentCoordinator?.childDidFinish(child: self)
    }
}
