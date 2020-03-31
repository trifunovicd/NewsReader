//
//  FavoritesCoordinator.swift
//  NewsReader
//
//  Created by Internship on 30/03/2020.
//  Copyright © 2020 Internship. All rights reserved.
//

import UIKit

class FavoritesCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var presenter: UINavigationController
    let controller: FavouritesTableViewController
    
    init(presenter: UINavigationController) {
        self.presenter = presenter
        
        let favoritesController = FavouritesTableViewController()
        let viewModel = FavoritesViewModel()
        favoritesController.favoriteViewModel = viewModel
        favoritesController.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        favoritesController.navigationItem.title = "Favorites"
        self.controller = favoritesController
    }
    
    func start() {
        setupNavigationBar()
        controller.favoriteViewModel.coordinatorDelegate = self
        presenter.pushViewController(controller, animated: false)
    }
    
    private func setupNavigationBar() {
        presenter.navigationBar.barTintColor = UIColor(red: 28.0/255.0, green: 68.0/255.0, blue: 156.0/255.0, alpha: 1.0)
        presenter.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        presenter.navigationBar.tintColor = UIColor.white
    }
}

extension FavoritesCoordinator: SingleArticleDelegate {
    
    func openSingleArticle(articles: [News], index: Int) {
        let child = SingleArticleCoordinator(presenter: presenter, articles: articles, index: index)
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.start()
    }
}

extension FavoritesCoordinator: CoordinatorDelegate {
    
    func childDidFinish(child: Coordinator) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
}
