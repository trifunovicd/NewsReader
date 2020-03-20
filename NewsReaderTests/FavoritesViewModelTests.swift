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
            var shouldRefreshTable = false
            var favorites: Results<Favorite>!
            
            beforeEach {
                sut = FavoritesViewModel()
                disposeBag = DisposeBag()
                sut.bindFetchFavorites().disposed(by: disposeBag)
                sut.setRemoveOption().disposed(by: disposeBag)
            }
            
            
            context("initial setup"){
                it("should be an empty array of preview articles") {
                    expect(sut.articlesPreview.value).to(beEmpty(), description: "Array must be empty!")
                }
                
                it("should be an empty array of favorites") {
                    expect(sut.favorites.value).to(beEmpty(), description: "Array must be empty!")
                }
            }
            
            
            context("on fetching data"){
                beforeEach {
                    sut.favoritesRequest.onNext(())
                }
                
                it("should not throw error") {
                    expect(sut.favoritesRequest).notTo(throwError())
                }
                
                context("it should match saved favorites") {
                    beforeEach {
                        do{
                            let realm = try Realm()
                            favorites = realm.objects(Favorite.self).sorted(byKeyPath: "dateSaved", ascending: false)
                        }
                        catch{
                            fail("Expecting to get failure")
                        }
                    }
                    
                    it("should get preview articles") {
                        expect(sut.articlesPreview.value.count).to(equal(favorites.count))
                    }
                    
                    it("should get all favorite articles") {
                        expect(sut.favorites.value.count).to(equal(favorites.count))
                    }
                }
            }
            
            
            context("remove favorite") {
                beforeEach {
                    Realm.Configuration.defaultConfiguration.inMemoryIdentifier = "testDatabase"
                    
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
                        
                        sut.favoritesRequest.onNext(())
                        
                    } catch  {
                        fail("Expecting to get failure")
                    }
                }
                
                it("should add article to favorites") {
                    do {
                        let realm = try Realm()
                        
                        let savedArticle = realm.objects(Favorite.self).filter("url = 'testFavoriteUrl'")
                        
                        expect(savedArticle.first?.url) == "testFavoriteUrl"
                        
                        
                    } catch  {
                        fail("Expecting to get failure")
                    }
                }
                
                it("should remove article from favorites") {
                    let articlePreview = ArticlePreview(title: "testFavoriteTitle", url: "testFavoriteUrl", urlToImage: "testFavoriteUrlToImage", isSelected: true)
                    sut.removeFromFavorites.onNext(articlePreview)

                    do {
                        let realm = try Realm()

                        let savedArticle = realm.objects(Favorite.self).filter("url = '\(articlePreview.url)'")

                        expect(savedArticle).to(beEmpty())


                    } catch  {
                        fail("Expecting to get failure")
                    }
                }
            }
            
            
            context("refresh table") {
                beforeEach {
                    sut.refreshTable.subscribe(onNext: {
                        shouldRefreshTable = true
                    }).disposed(by: disposeBag)
                    
                    sut.favoritesRequest.onNext(())
                }
                
                it("should refresh table on data fetched") {
                    expect(shouldRefreshTable).to(beTrue(), description: "Table must be refreshed!")
                }
            }
        }
    }
}
