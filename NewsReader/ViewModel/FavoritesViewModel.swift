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
    func bindFetchFavorites() -> Disposable{
    favoritesRequest.asObservable().flatMap(getFavoritesObservable).subscribe(onNext: { [weak self] favorites in
            self?.articlesPreview.accept(favorites.0)
            self?.favorites.accept(favorites.1)
            self?.refreshTable.onNext(())
        })
    }

    private func getFavoritesObservable() -> Observable<([ArticlePreview], [Favorite])> {
        var observable: Observable<([ArticlePreview], [Favorite])> = Observable.empty()
        var articlePreviewList: [ArticlePreview] = []
        
        do {
            let realm = try Realm()
            let favorites = realm.objects(Favorite.self).sorted(byKeyPath: "dateSaved", ascending: false)
            
            for favorite in favorites {
                let articlePreview = ArticlePreview(title: favorite.title, url: favorite.url, urlToImage: favorite.urlToImage, isSelected: true)
                
                articlePreviewList.append(articlePreview)
            }
            
            observable = Observable<([ArticlePreview], [Favorite])>.just((articlePreviewList, Array(favorites)))
            
        } catch  {
            print(error)
        }
        
        return observable
    }
    
    func setRemoveOption() -> Disposable{
        removeFromFavorites.asObservable().subscribe(onNext: { [weak self] articlePreview in
            
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


