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
    var favoriteArticles: BehaviorRelay<[Favorite]> = BehaviorRelay<[Favorite]>(value: [])
    
    let favoritesRequest =  PublishSubject<Void>()
    
    let refreshTable = PublishSubject<Void>()
    
    let removeFromFavorites = PublishSubject<Favorite>()
    
    
    func fetch() -> Disposable{
    favoritesRequest.asObservable().flatMap(getFavoritesObservable).subscribe(onNext: { [weak self] favorites in
            self?.favoriteArticles.accept(favorites)
            self?.refreshTable.onNext(())
        })
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
    
    func setRemoveOption() -> Disposable{
        removeFromFavorites.asObserver().subscribe(onNext: { [weak self] favorite in
            self?.removeFavorite(favorite: favorite)
            //self?.refreshTable.onNext(())
        })
    }
    
    private func removeFavorite(favorite: Favorite) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.delete(favorite)
            }
            
        } catch  {
            print(error)
        }
    }
}


