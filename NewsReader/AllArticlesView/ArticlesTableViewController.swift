//
//  ArticlesTableViewController.swift
//  NewsReader
//
//  Created by Internship on 25/02/2020.
//  Copyright © 2020 Internship. All rights reserved.
//

import UIKit
import os.log
import RxSwift
import RxCocoa
import RealmSwift

private let cellIdentifier = "ArticleTableViewCell"

class ArticlesTableViewController: UITableViewController {
    
    //MARK: Properties
    private let articleViewModel = AllArticlesViewModel(observable: getRequest(url: Urls.articleUrl.rawValue))
    
    private let myRefreshControl = UIRefreshControl()
    
    private let bag = DisposeBag()
    
    weak var parentCoordinator: ArticlesCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRefreshControl()
        
        tableView.register(ArticleTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.rowHeight = 90
        
        articleViewModel.bindFetch(observable: articleViewModel.getDataObservable(forceUpdate:), scheduler: MainScheduler.instance).disposed(by: bag)
        
        setObservers()
        
        articleViewModel.setSaveOption(scheduler: MainScheduler.instance).disposed(by: bag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //tabBarController?.navigationItem.title = "Factory"
        reload(forceUpdate: RefreshType.general)
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articleViewModel.articlesPreview.value.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ArticleTableViewCell else{
            fatalError("The dequeued cell is not an instance of ArticleTableViewCell.")
        }

        let article = articleViewModel.articlesPreview.value[indexPath.row]

        cell.configure(article)
        
        cell.onFavoriteClicked = { [weak self] in
            print("clicked")
            article.isSelected = !article.isSelected
            self?.articleViewModel.favoritesAction.onNext(article)
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        parentCoordinator?.openSingleArticle(articles: articleViewModel.articles.value, index: indexPath.row)
    }
    
    
    //MARK: Private Methods
    private func setupRefreshControl(){
        // Add Refresh Control to Table View
        if #available(iOS 10.0, *) {
            tableView.refreshControl = myRefreshControl
        } else {
            tableView.addSubview(myRefreshControl)
        }
        
        myRefreshControl.tintColor = .gray
        myRefreshControl.attributedTitle = NSAttributedString(string: "Fetching Data ...", attributes: [NSAttributedString.Key.foregroundColor:UIColor.gray])
        
        myRefreshControl.rx.controlEvent(.valueChanged).asObservable().subscribe(onNext: { [weak self] in
            self?.reload(forceUpdate: RefreshType.network)
        
        }).disposed(by: bag)
    }
    
    private func reload(forceUpdate: RefreshType) {
        articleViewModel.reloadRequest.onNext(forceUpdate)
    }
     
    private func setObservers() {
        articleViewModel.refreshTable.subscribe(onNext: { [weak self] in
            self?.tableView.reloadData()
        }).disposed(by: bag)
        
        articleViewModel.endRefreshing.subscribe(onNext: { [weak self] bool in
            self?.myRefreshControl.endRefreshing()
        }).disposed(by: bag)
        
        articleViewModel.alertOfError.subscribe(onNext: { [weak self] bool in
            let alert = self?.getErrorAlert()
            self?.present(alert!, animated: true, completion: nil)
            }).disposed(by: bag)
    }
    
    private func getErrorAlert() -> UIAlertController{
        let alert = UIAlertController(title: "Greška", message: "Ups, došlo je do pogreške.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "U redu", style: .default, handler: nil))
        
        return alert
    }
}
