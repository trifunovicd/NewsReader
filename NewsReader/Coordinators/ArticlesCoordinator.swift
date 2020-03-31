//
//  ArticlesCoordinator.swift
//  NewsReader
//
//  Created by Internship on 30/03/2020.
//  Copyright © 2020 Internship. All rights reserved.
//

import UIKit

class ArticlesCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var presenter: UINavigationController
    let controller: ArticlesTableViewController
    
    init(presenter: UINavigationController) {
        self.presenter = presenter
        
        let articleController = ArticlesTableViewController()
        let viewModel = AllArticlesViewModel(observable: getRequest(url: Urls.articleUrl.rawValue))
        articleController.articleViewModel = viewModel
        articleController.tabBarItem = UITabBarItem(tabBarSystemItem: .mostRecent, tag: 0)
        articleController.navigationItem.title = "Factory"
        self.controller = articleController
    }
    
    func start() {
        setupNavigationBar()
        controller.articleViewModel.coordinatorDelegate = self
        presenter.pushViewController(controller, animated: false)
    }
    
    private func setupNavigationBar() {
        presenter.navigationBar.barTintColor = UIColor(red: 28.0/255.0, green: 68.0/255.0, blue: 156.0/255.0, alpha: 1.0)
        presenter.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        presenter.navigationBar.tintColor = UIColor.white
    }
}

extension ArticlesCoordinator: SingleArticleDelegate {
    
    func openSingleArticle(articles: [News], index: Int) {
        let child = SingleArticleCoordinator(presenter: presenter, articles: articles, index: index)
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.start()
    }
}

extension ArticlesCoordinator: CoordinatorDelegate {
    
    func childDidFinish(child: Coordinator) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
}
