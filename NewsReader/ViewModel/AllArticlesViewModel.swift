//
//  AllArticlesViewModel.swift
//  NewsReader
//
//  Created by Internship on 10/03/2020.
//  Copyright © 2020 Internship. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum RefreshType {
    case network
    case general
}

class AllArticlesViewModel {
    
    //MARK: Properties
    var articles: BehaviorRelay<[ArticleDetails]> = BehaviorRelay<[ArticleDetails]>(value: [])
    
    let reloadRequest = PublishSubject<RefreshType>()
    
    let endRefreshing = PublishSubject<Void>()
    
    let refreshTable = PublishSubject<Void>()
    
    let alertOfError = PublishSubject<Void>()
    
   
    
    //MARK: Private Methods
    func bindFetch() -> Disposable{
        reloadRequest
            .asObservable()
            .flatMap(getArticlesObservable)
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .success(let allArticles):
                    self?.articles.accept(allArticles.articles)
                    self?.endRefreshing.onNext(())
                    self?.refreshTable.onNext(())
                    self?.setDate()
                    
                case .failure(let error):
                    print(error)
                    self?.endRefreshing.onNext(())
                    self?.alertOfError.onNext(())
                    
                }
            })
    }
    
    private func getArticlesObservable(forceUpdate: RefreshType) -> Observable<Result<Articles, Error>>{
        let observable: Observable<Articles>
        
        
        if shouldFetchFromInternet(forceUpdate) {
            observable = getRequest(url: Urls.articleUrl.rawValue)
        }
        else {
            //local fetch
            observable = Observable.empty()
        }
        
        return observable.map { (articles) -> Result<Articles,Error> in
            return Result.success(articles)
        }.catchError { (error) -> Observable<Result<Articles, Error>> in
            let result = Result<Articles,Error>.failure(error)
            return Observable.just(result)
        }
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
    
    private func shouldFetchFromInternet(_ forceUpdate: RefreshType) -> Bool{
        var onlineFetch = false
        
        if let oldDate = getDate() {
            let todayDate = Date()
            let difference = (todayDate.timeIntervalSince1970 * 1000) - (oldDate.timeIntervalSince1970 * 1000)
            let seconds = difference / 1000;
            let minutes = seconds / 60;
            
            if minutes > 5 || forceUpdate == RefreshType.network {
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
