//
//  FavouritesTableViewController.swift
//  NewsReader
//
//  Created by Internship on 13/03/2020.
//  Copyright © 2020 Internship. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

private let cellIdentifier = "FavoriteTableViewCell"

class FavouritesTableViewController: UITableViewController {
    
    //MARK: Properties
    private let favoriteViewModel = FavoritesViewModel()
    private let bag = DisposeBag()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(FavoriteTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.rowHeight = 90
        
        setObservers()
        
        favoriteViewModel.bindFetchFavorites().disposed(by: bag)
        
        favoriteViewModel.setRemoveOption().disposed(by: bag)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.navigationItem.title = "Favorites"
        favoriteViewModel.favoritesRequest.onNext(())
    }

    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteViewModel.articlesPreview.value.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? FavoriteTableViewCell else{
            fatalError("The dequeued cell is not an instance of FavoriteTableViewCell.")
        }

        let article = favoriteViewModel.articlesPreview.value[indexPath.row]

        cell.configure(article)
        
        cell.onFavoriteClicked = { [weak self] in
            print("clicked")
            self?.favoriteViewModel.removeFromFavorites.onNext(article)
            self?.favoriteViewModel.favoritesRequest.onNext(())
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let articleCollectionViewController = ArticleCollectionViewController(collectionViewLayout: layout)

        let singleArticleViewModel = SingleArticleViewModel(articles:favoriteViewModel.favorites.value, index: indexPath.row)

        articleCollectionViewController.singleArticleViewModel = singleArticleViewModel

        navigationController?.pushViewController(articleCollectionViewController, animated: true)
    }
    

    private func setObservers() {
        favoriteViewModel.refreshTable.subscribe(onNext: { [weak self] in
            self?.tableView.reloadData()
        }).disposed(by: bag)
    }
}
