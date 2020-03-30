//
//  FavoritesCoordinator.swift
//  NewsReader
//
//  Created by Internship on 30/03/2020.
//  Copyright © 2020 Internship. All rights reserved.
//

import UIKit

class FavoritesCoordinator: NSObject, Coordinator, UINavigationControllerDelegate, SingleArticle{
    var childCoordinators: [Coordinator] = []
    var presenter: UINavigationController
    
    init(presenter: UINavigationController) {
        self.presenter = presenter
    }
    
    func start() {
        setupNavigationBar()
        presenter.delegate = self
        
        let vc = FavouritesTableViewController()
        vc.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        vc.navigationItem.title = "Favorites"
        vc.parentCoordinator = self
        
        presenter.pushViewController(vc, animated: false)
    }
    
    func openSingleArticle(articles: [News], index: Int) {
        let child = SingleArticleCoordinator(presenter: presenter, articles: articles, index: index)
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
        if let articleCollectionViewController = fromViewController as? ArticleCollectionViewController {
            // We're popping a buy view controller; end its coordinator
            childDidFinish(articleCollectionViewController.parentCoordinator)
        }
    }
    
    private func setupNavigationBar() {
        presenter.navigationBar.barTintColor = UIColor(red: 28.0/255.0, green: 68.0/255.0, blue: 156.0/255.0, alpha: 1.0)
        presenter.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        presenter.navigationBar.tintColor = UIColor.white
    }
}
