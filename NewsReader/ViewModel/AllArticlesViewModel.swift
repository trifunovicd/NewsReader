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
    var articlesPreview: BehaviorRelay<[ArticlePreview]> = BehaviorRelay<[ArticlePreview]>(value: [])
    
    var articles: BehaviorRelay<[ArticleDetails]> = BehaviorRelay<[ArticleDetails]>(value: [])
    
    let reloadRequest = PublishSubject<RefreshType>()
    
    let endRefreshing = PublishSubject<Void>()
    
    let refreshTable = PublishSubject<Void>()
    
    let alertOfError = PublishSubject<Void>()
    
    let favoritesAction = PublishSubject<ArticlePreview>()
    
    
    //MARK: Private Methods
    func bindFetch() -> Disposable{
        reloadRequest
            .asObservable()
            .flatMap(getDataObservable)
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .success(let data):
                    self?.articlesPreview.accept(data.0)
                    self?.articles.accept(data.1.articles)
                    self?.endRefreshing.onNext(())
                    self?.refreshTable.onNext(())
                    
                    if data.2 {
                        self?.setDate()
                        self?.removeLocalData()
                        self?.setLocalData(articles: data.1.articles)
                    }
                    
                case .failure(let error):
                    print(error)
                    self?.endRefreshing.onNext(())
                    self?.alertOfError.onNext(())
                    
                }
            })
    }
    
    private func getDataObservable(forceUpdate: RefreshType) -> Observable<Result<([ArticlePreview], Articles, Bool), Error>>{
        var articlePreviewList: [ArticlePreview] = []
        
        let articleObservable = getArticleObservable(isForceUpdate: forceUpdate)
        let favoriteObservable = getFavoritesObservable()
        
        return Observable.combineLatest(articleObservable.0, favoriteObservable, resultSelector: { allArticles, favorites in
            
            for article in allArticles.articles {
                let articlePreview = ArticlePreview(title: article.title, url: article.url, urlToImage: article.urlToImage, isSelected: false)
                
                for favorite in favorites {
                    if article.url == favorite.url {
                        articlePreview.isSelected = true
                    }
                }
                articlePreviewList.append(articlePreview)
            }
            return (articlePreviewList, allArticles, articleObservable.1)
            
        }).map { (articles) -> Result<([ArticlePreview], Articles, Bool),Error> in
            return Result.success(articles)
            
        }.catchError { error -> Observable<Result<([ArticlePreview], Articles, Bool), Error>> in
            let result = Result<([ArticlePreview], Articles, Bool),Error>.failure(error)
            return Observable.just(result)
        }
        
    }
    
    private func getArticleObservable(isForceUpdate: RefreshType) -> (Observable<Articles>, Bool){
        let observable: Observable<Articles>
        let isOnlineFetch: Bool
        
        if shouldFetchFromInternet(isForceUpdate) {
            print("Online fetching...")
            isOnlineFetch = true
            observable = getRequest(url: Urls.articleUrl.rawValue)
        }
        else {
            print("Local fetching...")
            isOnlineFetch = false
            observable = getLocalData()
        }
        
        return (observable, isOnlineFetch)
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
            let articles = realm.objects(ArticleDetails.self)
            
            let allArticles = Articles()
            allArticles.articles = Array(articles)
                
            observable = Observable<Articles>.just(allArticles)
            
        } catch  {
            print(error)
        }

        return observable
    }
    
    private func setLocalData(articles: [ArticleDetails]) {
        do {
            let realm = try Realm()
            
            for article in articles {
                article.localStored = true
            }
            
            try realm.write {
                realm.add(articles)
            }
            
        } catch  {
            print(error)
        }
    }
    
    private func removeLocalData() {
        do {
            let realm = try Realm()
            let articles = realm.objects(ArticleDetails.self).filter("localStored = true")
            
            try realm.write {
                realm.delete(articles)
            }

        } catch  {
            print(error)
        }
    }
    
    func setSaveOption() -> Disposable{
        favoritesAction.asObservable().subscribe(onNext: { [weak self] articlePreview in
            let favorite = Favorite()
            
            for article in self?.articles.value ?? [] {
                if article.url == articlePreview.url {
                    favorite.title = article.title
                    favorite.articleDescription = article.articleDescription
                    favorite.url = article.url
                    favorite.urlToImage = article.urlToImage
                }
            }
            
            if articlePreview.isSelected {
                self?.saveFavorite(favorite: favorite)
            }
            else {
                self?.removeFavorite(favorite: favorite)
            }
        })
    }
    
    private func saveFavorite(favorite: Favorite) {
        do {
            favorite.dateSaved = Date()
            
            let realm = try Realm()
            try realm.write {
                realm.add(favorite)
            }
            refreshTable.onNext(())
            
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
            refreshTable.onNext(())
            
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
                onlineFetch = true
            }
        }
        else {
            onlineFetch = true
        }
        
        return onlineFetch
    }
}
