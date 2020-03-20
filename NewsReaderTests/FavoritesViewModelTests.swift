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
            
            beforeEach {
                sut = FavoritesViewModel()
                disposeBag = DisposeBag()
                sut.bindFetchFavorites().disposed(by: disposeBag)
                sut.setRemoveOption().disposed(by: disposeBag)
                
                sut.refreshTable.subscribe(onNext: {
                    shouldRefreshTable = true
                }).disposed(by: disposeBag)
                
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
                    sut.favoritesRequest.onNext(())
                }
                
                it("should refresh table") {
                    expect(shouldRefreshTable).to(beTrue(), description: "Table must be refreshed!")
                }
                
                it("should show empty list of preview articles") {
                    expect(sut.articlesPreview.value).to(beEmpty(), description: "Array must be empty!")
                }
                
                it("should contain empty list of favorites") {
                    expect(sut.favorites.value).to(beEmpty(), description: "Array must be empty!")
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
                        
                        sut.favoritesRequest.onNext(())
                        
                    } catch  {
                        fail("Expecting to get failure")
                    }
                }
                
                it("should refresh table") {
                    expect(shouldRefreshTable).to(beTrue(), description: "Table must be refreshed!")
                }
                
                it("should show preview of favorite articles") {
                    expect(sut.articlesPreview.value.count).to(equal(1))
                }
                
                it("should contain list of all favorite articles") {
                    expect(sut.favorites.value.count).to(equal(1))
                }
                
                
                context("on remove favorite") {
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
            }
        }
    }
}
