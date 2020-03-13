//
//  TabBarController.swift
//  NewsReader
//
//  Created by Internship on 13/03/2020.
//  Copyright © 2020 Internship. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let articlesTableViewController = ArticlesTableViewController()
        articlesTableViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .mostRecent, tag: 0)

        let favouritesTableViewController = FavouritesTableViewController()
        favouritesTableViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)

        let tabBarList = [articlesTableViewController, favouritesTableViewController]

        viewControllers = tabBarList
        
    }
    
}
