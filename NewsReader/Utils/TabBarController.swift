//
//  TabBarController.swift
//  NewsReader
//
//  Created by Internship on 13/03/2020.
//  Copyright © 2020 Internship. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    let articlesCoordinator = ArticlesCoordinator(presenter: UINavigationController())
    let favoritesCoordinator = FavoritesCoordinator(presenter: UINavigationController())

    override func viewDidLoad() {
        super.viewDidLoad()

        articlesCoordinator.start()
        favoritesCoordinator.start()

        let tabBarList = [articlesCoordinator.presenter, favoritesCoordinator.presenter]

        viewControllers = tabBarList

    }
}
