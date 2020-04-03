//
//  AppCoordinator.swift
//  NewsReader
//
//  Created by Internship on 03/04/2020.
//  Copyright © 2020 Internship. All rights reserved.
//

import UIKit

class AppCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    let window: UIWindow
    var presenter: UINavigationController
    let tabController: UITabBarController
    let articlesCoordinator: ArticlesCoordinator
    let favoritesCoordinator: FavoritesCoordinator
    
    init(window: UIWindow) {
        self.window = window
        self.presenter = UINavigationController()
        
        self.tabController = UITabBarController()

        self.articlesCoordinator = ArticlesCoordinator(presenter: UINavigationController())
        self.favoritesCoordinator = FavoritesCoordinator(presenter: UINavigationController())
        
        childCoordinators.append(articlesCoordinator)
        childCoordinators.append(favoritesCoordinator)

        articlesCoordinator.start()
        favoritesCoordinator.start()

        let tabBarList = [articlesCoordinator.presenter, favoritesCoordinator.presenter]

        tabController.viewControllers = tabBarList
    }
    
    func start() {
        window.rootViewController = tabController
        window.makeKeyAndVisible()
    }
}
