//
//  FavoritesViewModel.swift
//  NewsReader
//
//  Created by Internship on 16/03/2020.
//  Copyright © 2020 Internship. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift

class FavoritesViewModel {
    
    //MARK: Properties
    var articlesPreview: BehaviorRelay<[ArticlePreview]> = BehaviorRelay<[ArticlePreview]>(value: [])
    
    var favorites: BehaviorRelay<[Favorite]> = BehaviorRelay<[Favorite]>(value: [])
    
    let favoritesRequest =  PublishSubject<Void>()
    
    let refreshTable = PublishSubject<Void>()
    
    let removeFromFavorites = PublishSubject<ArticlePreview>()
    
    
    //MARK: Private Methods
    func bindFetchFavorites(observable: @escaping ()-> Observable<Result<([ArticlePreview], [Favorite]), Error>>, scheduler: SchedulerType) -> Disposable{
        favoritesRequest.asObservable().observeOn(scheduler) .flatMap(observable).subscribe(onNext: { [weak self] result in
            
            switch result {
            case .success(let data):
                self?.articlesPreview.accept(data.0)
                self?.favorites.accept(data.1)
                self?.refreshTable.onNext(())
            case .failure(let error):
                print(error)
            }
                
        })
    }

    func getFavoritesObservable() -> Observable<Result<([ArticlePreview], [Favorite]), Error>> {
        var observable: Observable<Result<([ArticlePreview], [Favorite]), Error>> = Observable.empty()
        var articlePreviewList: [ArticlePreview] = []
        
        do {
            let realm = try Realm()
            let favorites = realm.objects(Favorite.self).sorted(byKeyPath: "dateSaved", ascending: false)
            
            for favorite in favorites {
                let articlePreview = ArticlePreview(title: favorite.title, url: favorite.url, urlToImage: favorite.urlToImage, isSelected: true)
                
                articlePreviewList.append(articlePreview)
            }
            
            observable = Observable<Result<([ArticlePreview], [Favorite]), Error>>.just(.success((articlePreviewList, Array(favorites))))
            
            
        } catch  {
            observable = Observable<Result<([ArticlePreview], [Favorite]), Error>>.just(.failure(error))
        }
        
        return observable
    }
    
    func setRemoveOption(scheduler: SchedulerType) -> Disposable{
        removeFromFavorites.asObservable().observeOn(scheduler).subscribe(onNext: { [weak self] articlePreview in
            
            let favorite = Favorite()
            
            for article in self?.favorites.value ?? [] {
                if article.url == articlePreview.url {
                    favorite.title = article.title
                    favorite.articleDescription = article.articleDescription
                    favorite.url = article.url
                    favorite.urlToImage = article.urlToImage
                }
            }
            self?.removeFavorite(favorite: favorite)
        })
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
}


