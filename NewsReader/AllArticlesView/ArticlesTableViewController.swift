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

private let cellIdentifier = "ArticleTableViewCell"

class ArticlesTableViewController: UITableViewController {
    
    //MARK: Properties
    private let articleViewModel = ArticleViewModel()
    
    private let myRefreshControl = UIRefreshControl()
    
    private let bag = DisposeBag()
    
    private var pullToRefresh: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        
        setupRefreshControl()
        
        tableView.register(ArticleTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.rowHeight = 90
        
        articleViewModel.bindFetch()
        
        setObservers()
        
        reload()
        
    }

    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articleViewModel.getArticles().value.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ArticleTableViewCell else{
            fatalError("The dequeued cell is not an instance of ArticleTableViewCell.")
        }

        let article = articleViewModel.getArticles().value[indexPath.row]

        cell.articleNameLabel.text = article.title
        cell.articleImageView.loadImageUsingUrlString(urlString: article.urlToImage)

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let articleCollectionViewController = ArticleCollectionViewController(collectionViewLayout: layout)

        articleCollectionViewController.articles = articleViewModel.getArticles().value
        articleCollectionViewController.indexPath = indexPath

        navigationController?.pushViewController(articleCollectionViewController, animated: true)
    }
    
    
    //MARK: Private Methods
    private func setupNavigationBar(){
        navigationItem.title = "Factory"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barTintColor = UIColor(red: 28.0/255.0, green: 68.0/255.0, blue: 156.0/255.0, alpha: 1.0)
    }
    
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
            self?.pullToRefresh = true
            self?.reload()
        
        }).disposed(by: bag)
    }
    
    private func reload() {
        articleViewModel.setPullToRefresh(pullToRefresh)
        articleViewModel.getReloadRequest().onNext(())
        pullToRefresh = false
    }
     
    private func setObservers() {
        articleViewModel.getRefreshTable().subscribe(onNext: { [weak self] in
            self?.tableView.reloadData()
        }).disposed(by: bag)
        
        articleViewModel.getEndRefreshing().subscribe(onNext: { [weak self] in
            self?.myRefreshControl.endRefreshing()
        }).disposed(by: bag)
        
        articleViewModel.getAlertOfError().subscribe(onNext: { [weak self] in
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
