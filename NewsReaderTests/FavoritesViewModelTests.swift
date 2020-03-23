//
//  FavoritesViewModelTests.swift
//  NewsReaderTests
//
//  Created by Internship on 19/03/2020.
//  Copyright © 2020 Internship. All rights reserved.
//

import XCTest
import RxSwift
import RxTest
import Quick
import Nimble
import RealmSwift
@testable import NewsReader

class FavoritesViewModelTests: QuickSpec {
    override func spec() {
        describe("FavoritesViewModel"){
            var sut: FavoritesViewModel!
            var disposeBag: DisposeBag!
            var scheduler: TestScheduler!
            var result: TestableObserver<[ArticlePreview]>!
            var favorites: [ArticlePreview]!
            var article: ArticlePreview!
            var articleToDelete: TestableObserver<ArticlePreview>!
            
            
            beforeEach {
                sut = FavoritesViewModel()
                disposeBag = DisposeBag()
                scheduler = TestScheduler(initialClock: 0)
                result = scheduler.createObserver([ArticlePreview].self)
                articleToDelete = scheduler.createObserver(ArticlePreview.self)
                favorites = []
                
                Realm.Configuration.defaultConfiguration.inMemoryIdentifier = "testDatabase"
                
                do{
                    let realm = try Realm()
                    
                    try realm.write {
                      realm.deleteAll()
                    }
                }
                catch{
                    fail("Expecting to get failure")
                }
            }
            
            
            context("if database is empty") {
                beforeEach {
                    sut.bindFetchFavorites(observable: {.empty()}, scheduler: scheduler).disposed(by: disposeBag)
                    
                    sut.articlesPreview.bind(to: result).disposed(by: disposeBag)
                    
                    sut.favoritesRequest.onNext(())
                    
                    scheduler.start()
                }
                
                it("should show empty list of preview articles") {
                    expect(result.events).to(equal([.next(0, [])]))
                }
            }
            
            
            context("if database contains favorite articles") {
                beforeEach {
                    let favorite = Favorite()
                    favorite.title = "testFavoriteTitle"
                    favorite.articleDescription = "testFavoriteDescription"
                    favorite.url = "testFavoriteUrl"
                    favorite.urlToImage = "testFavoriteUrlToImage"
                    favorite.dateSaved = Date()

                    do {
                        let realm = try Realm()

                        try realm.write {
                            realm.add(favorite)
                        }

                    } catch  {
                        fail("Expecting to get failure")
                    }
                    
                    let articlePreview = ArticlePreview(title: favorite.title, url: favorite.url, urlToImage: favorite.urlToImage, isSelected: true)
                    
                    favorites.append(articlePreview)
                    article = articlePreview
                    
                    sut.bindFetchFavorites(observable: sut.getFavoritesObservable, scheduler: scheduler).disposed(by: disposeBag)
                    
                    sut.articlesPreview.bind(to: result).disposed(by: disposeBag)
                    
                    sut.favoritesRequest.onNext(())
                }

                
                it("should show preview of favorite articles") {
                    scheduler.start()
                    expect(result.events).to(equal([.next(0, []), .next(1, favorites)]))
                }
                
                
                context("on remove favorite") {
                    beforeEach {
                        sut.setRemoveOption(scheduler: scheduler).disposed(by: disposeBag)
                        
                        sut.removeFromFavorites.bind(to: articleToDelete).disposed(by: disposeBag)
                        
                        sut.removeFromFavorites.onNext(article)
                        
                        scheduler.start()
                    }
                    
                    it("should return article that needs to be removed") {
                        expect(articleToDelete.events).to(equal([.next(0, article)]))
                    }
                    
                    it("should remove article from favorites") {
                        do {
                            let realm = try Realm()

                            let savedArticle = realm.objects(Favorite.self).filter("url = '\(article.url)'")

                            expect(savedArticle).to(beEmpty())


                        } catch  {
                            fail("Expecting to get failure")
                        }
                    }
                }
            }
        }
    }
}
