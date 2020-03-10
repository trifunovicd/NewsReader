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
    
    private var articles: BehaviorRelay<[ArticleDetails]> = BehaviorRelay<[ArticleDetails]>(value: [])
    
    private let myRefreshControl = UIRefreshControl()
    
    private let bag = DisposeBag()
    
    private let reloadRequest = PublishSubject<Void>()
    
    private var pullToRefresh: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        
        setupRefreshControl()
        
        tableView.register(ArticleTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.rowHeight = 90
        
        bindFetch()
        
        articles.asObservable().subscribe(onNext: { [weak self] value in
            self?.tableView.reloadData()
        })
        .disposed(by: bag)
        
        reload()
        
    }

    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.value.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ArticleTableViewCell else{
            fatalError("The dequeued cell is not an instance of ArticleTableViewCell.")
        }

        let article = articles.value[indexPath.row]

        cell.articleNameLabel.text = article.title
        cell.articleImageView.loadImageUsingUrlString(urlString: article.urlToImage)

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let articleCollectionViewController = ArticleCollectionViewController(collectionViewLayout: layout)

        articleCollectionViewController.articles = articles.value
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
        reloadRequest.onNext(())
        pullToRefresh = false
    }
     
    private func bindFetch() {
        reloadRequest
            .asObservable()
            .flatMap(getArticlesObservable)
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .success(let allArticles):
                    self?.myRefreshControl.endRefreshing()
                    self?.articles.accept(allArticles.articles)
                    self?.setDate()
                    
                case .failure(let error):
                    print(error)
                    self?.myRefreshControl.endRefreshing()

                    let alert = self?.getErrorAlert()
                    self?.present(alert!, animated: true, completion: nil)
                }
            }).disposed(by: bag)
        
    }
    
    private func getArticlesObservable() -> Observable<Result<Articles, Error>>{
        let observable: Observable<Articles>
        
        if shouldFetchFromInternet(pullToRefresh) {
            let request = Request()
            observable = request.get(url: Urls.articleUrl.rawValue)
        }
        else {
            //local
            observable = Observable.empty()
        }
        
        return observable.map { (articles) -> Result<Articles,Error> in
            return Result.success(articles)
        }.catchError { (error) -> Observable<Result<Articles, Error>> in
            let result = Result<Articles,Error>.failure(error)
            return Observable.just(result)
        }
    }
    
    private func getErrorAlert() -> UIAlertController{
        let alert = UIAlertController(title: "Greška", message: "Ups, došlo je do pogreške.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "U redu", style: .default, handler: nil))
        
        return alert
    }
    
    private func setDate() {
        let defaults = UserDefaults.standard
        defaults.set(Date(), forKey: "Date")
    }
    
    private func getDate() -> Date?{
        let defaults = UserDefaults.standard
        let date = defaults.value(forKey: "Date") as? Date
        return date
    }
    
    private func shouldFetchFromInternet(_ pullToRefresh: Bool) -> Bool{
        var onlineFetch = false
        
        if let oldDate = getDate() {
            let todayDate = Date()
            let difference = (todayDate.timeIntervalSince1970 * 1000) - (oldDate.timeIntervalSince1970 * 1000)
            let seconds = difference / 1000;
            let minutes = seconds / 60;
            
            if minutes > 5 || pullToRefresh {
                print("Online fetching...")
                onlineFetch = true
            }
        }
        else {
            onlineFetch = true
        }
        
        return onlineFetch
    }
}
