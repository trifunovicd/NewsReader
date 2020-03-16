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
import RealmSwift

enum RefreshType {
    case network
    case general
}

class AllArticlesViewModel {
    
    //MARK: Properties
    var articles: BehaviorRelay<[Favorite]> = BehaviorRelay<[Favorite]>(value: [])
    
    let reloadRequest = PublishSubject<RefreshType>()
    
    let endRefreshing = PublishSubject<Void>()
    
    let refreshTable = PublishSubject<Void>()
    
    let alertOfError = PublishSubject<Void>()
    
    let saveToFavorites = PublishSubject<Favorite>()
    
   
    
    //MARK: Private Methods
    func bindFetch() -> Disposable{
        reloadRequest
            .asObservable()
            .flatMap(getDataObservable)
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .success(let allArticles):
                    self?.articles.accept(allArticles)
                    self?.endRefreshing.onNext(())
                    self?.refreshTable.onNext(())
                    self?.setDate()
//                    self?.removeArticles()
//                    self?.saveArticles(articles: allArticles)
                    
                case .failure(let error):
                    print(error)
                    self?.endRefreshing.onNext(())
                    self?.alertOfError.onNext(())
                    
                }
            })
    }
    
    private func getDataObservable(forceUpdate: RefreshType) -> Observable<Result<[Favorite], Error>>{
        var newArticleList: [Favorite] = []
        
        let articleObservable = getArticleObservable(isForceUpdate: forceUpdate)
        let favoriteObservable = getFavoritesObservable()
        
        let observable = Observable.combineLatest(articleObservable, favoriteObservable, resultSelector: { allArticles, favorites in
            
            for article in allArticles.articles {
                let newArticle = Favorite()
                newArticle.url = article.url
                newArticle.title = article.title
                newArticle.urlToImage = article.urlToImage
                
                for favorite in favorites {
                    
                    if article.url == favorite.url {
                        newArticle.isSelected = true
                    }
                }
                newArticleList.append(newArticle)
            }
            return newArticleList
        }).map { (articles) -> Result<[Favorite],Error> in
            return Result.success(articles)
        }
        return observable
//        return observable.map { (articles) -> Result<Articles,Error> in
//            return Result.success(articles)
//        }.catchError { (error) -> Observable<Result<Articles, Error>> in
//            let result = Result<Articles,Error>.failure(error)
//            return Observable.just(result)
//        }
    }
    
    private func getArticleObservable(isForceUpdate: RefreshType) -> Observable<Articles> {
        let observable: Observable<Articles>
        
        if shouldFetchFromInternet(isForceUpdate) {
            observable = getRequest(url: Urls.articleUrl.rawValue)
        }
        else {
            observable = Observable.empty()
        }
        
        return observable
    }
    
    private func getFavoritesObservable() -> Observable<[Favorite]> {
        var observable: Observable<[Favorite]> = Observable.empty()
        
        do {
            let realm = try Realm()
            let favorites = realm.objects(Favorite.self)
            observable = Observable<[Favorite]>.just(Array(favorites))
            
        } catch  {
            print(error)
        }
        
        return observable
    }
    
    private func getLocalData() -> Observable<Articles>{
        var observable: Observable<Articles> = Observable.empty()
        
        do {
            let realm = try Realm()
            let articles = realm.objects(Articles.self)
            observable = Observable<Articles>.just(articles.first!)
            
        } catch  {
            print(error)
        }
        
        return observable
    }
    
    func setSaveOption() -> Disposable{
        saveToFavorites.asObserver().subscribe(onNext: { [weak self] favorite in
            if favorite.isSelected {
                self?.saveFavorite(favorite: favorite)
            }
            else {
                self?.removeFavorite(favorite: favorite)
            }
            
            
        })
    }
    
    private func saveFavorite(favorite: Favorite) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(favorite)
            }
            
        } catch  {
            print(error)
        }
    }
    
    private func removeFavorite(favorite: Favorite) {
        do {
            let realm = try Realm()
            
            let savedArticle = realm.objects(Favorite.self).filter("url = '\(favorite.url)'")
            
            try realm.write {
                realm.delete(savedArticle)
            }
            
        } catch  {
            print(error)
        }
    }
    
    private func saveArticles(articles: Articles) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(articles)
            }
            
        } catch  {
            print(error)
        }
    }
    
    private func removeArticles() {
        do {
            let realm = try Realm()
            let articles = realm.objects(Articles.self)
            try realm.write {
                realm.delete(articles)
            }
            
        } catch  {
            print(error)
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
