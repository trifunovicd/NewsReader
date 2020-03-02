//
//  ArticlesTableViewController.swift
//  NewsReader
//
//  Created by Internship on 25/02/2020.
//  Copyright © 2020 Internship. All rights reserved.
//

import UIKit
import os.log

private let cellIdentifier = "ArticleTableViewCell"

class ArticlesTableViewController: UITableViewController {
    
    //MARK: Properties
    private var articles = [ArticleDetails]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private let myRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        
        setupRefreshControl()
        
        tableView.register(ArticleTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.rowHeight = 90
        
        loadNews()
    }

    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ArticleTableViewCell else{
            fatalError("The dequeued cell is not an instance of ArticleTableViewCell.")
        }
        
        let article = articles[indexPath.row]
        
        cell.articleNameLabel.text = article.title
        cell.articleImageView.loadImageUsingUrlString(urlString: article.urlToImage)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let articleCollectionViewController = ArticleCollectionViewController(collectionViewLayout: layout)
        
        articleCollectionViewController.articles = articles
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
        
        myRefreshControl.addTarget(self, action: #selector(loadNews), for: .valueChanged)
        myRefreshControl.tintColor = .gray
        myRefreshControl.attributedTitle = NSAttributedString(string: "Fetching Data ...", attributes: [NSAttributedString.Key.foregroundColor:UIColor.gray])
    }
    
    @objc private func loadNews() {
        let articleRequest = ArticleRequest()
        articleRequest.getArticles { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
                self?.myRefreshControl.endRefreshing()
            case .success(let articles):
                self?.articles = articles
                self?.myRefreshControl.endRefreshing()
            }
        }
    }
}
