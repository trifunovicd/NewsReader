//
//  AllArticlesViewModelTests.swift
//  NewsReaderTests
//
//  Created by Internship on 24/03/2020.
//  Copyright © 2020 Internship. All rights reserved.
//

import XCTest
import RxSwift
import RxTest
import Quick
import Nimble
import RealmSwift
@testable import NewsReader

class AllArticlesViewModelTests: QuickSpec {
    override func spec() {
        describe("AllArticlesViewModel") {
            var sut: AllArticlesViewModel!
            var disposeBag: DisposeBag!
            var scheduler: TestScheduler!
            var result: TestableObserver<[ArticlePreview]>!
            //var errorAlert: TestableObserver<Bool>!
            //var endRefreshing: TestableObserver<Bool>!
            var articleToManage: TestableObserver<ArticlePreview>!
            var article: ArticlePreview!
            var generalRefresh: RefreshType!
            var networkRefresh: RefreshType!
            
            
            beforeEach {
                sut = AllArticlesViewModel()
                disposeBag = DisposeBag()
                scheduler = TestScheduler(initialClock: 0)
                result = scheduler.createObserver([ArticlePreview].self)
                //errorAlert = scheduler.createObserver(Bool.self)
                //endRefreshing = scheduler.createObserver(Bool.self)
                articleToManage = scheduler.createObserver(ArticlePreview.self)
                generalRefresh = .general
                networkRefresh = .network
                
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
            
            
            context("if error occurred") {
                beforeEach {
                    sut.bindFetch(observable: {generalRefresh in .error(DataError.noDataAvailable)}, scheduler: scheduler).disposed(by: disposeBag)
                    
                    sut.articlesPreview.bind(to: result).disposed(by: disposeBag)
                    
                    //sut.alertOfError.bind(to: errorAlert).disposed(by: disposeBag)
                    
                    //sut.endRefreshing.bind(to: endRefreshing).disposed(by: disposeBag)
                    
                    sut.reloadRequest.onNext(generalRefresh)
                    
                    scheduler.start()
                }
                
                it("should end refreshing") {
                    //expect(endRefreshing.events).to(equal([.next(0, true)]))
                }
                
                it("should alert of error") {
                    //sut.alertOfError.onNext(true)
                    //expect(errorAlert.events).to(equal([.next(0, true)]))
                }
                
                it("should show empty list of preview articles") {
                    expect(result.events).to(equal([.next(0, [])]))
                }
            }
            
            
            context("if fetch was successful") {
                beforeEach {
                    sut.bindFetch(observable: sut.getDataObservable(forceUpdate:), scheduler: scheduler).disposed(by: disposeBag)
                    
                    sut.articlesPreview.bind(to: result).disposed(by: disposeBag)
                    
                    //sut.endRefreshing.bind(to: endRefreshing).disposed(by: disposeBag)
                    
                    sut.reloadRequest.onNext(generalRefresh)
                    
                    scheduler.start()
                }
                
                it("should end refreshing") {
                    //expect(endRefreshing.events).to(equal([.next(0, true)]))
                }
                
                it("should show preview of articles") {
                    //expect(result.events).to(equal([.next(0, [])]))
                }
            }
            
            
            context("on force update") {
                beforeEach {
                    sut.bindFetch(observable: sut.getDataObservable(forceUpdate:), scheduler: scheduler).disposed(by: disposeBag)
                    
                    sut.articlesPreview.bind(to: result).disposed(by: disposeBag)
                    
                    //sut.endRefreshing.bind(to: endRefreshing).disposed(by: disposeBag)
                    
                    sut.reloadRequest.onNext(networkRefresh)
                    
                    scheduler.start()
                }
                
                it("should end refreshing") {
                    //expect(endRefreshing.events).to(equal([.next(0, true)]))
                }
                
                it("should show preview of articles") {
                    //expect(result.events).to(equal([.next(0, [])]))
                }
            }
            
            
            context("on article save") {
                beforeEach {
                    article = ArticlePreview(title: "testTitle", url: "testUrl", urlToImage: "testUrlToImage", isSelected: true)
                    
                    sut.setSaveOption(scheduler: scheduler).disposed(by: disposeBag)
                    
                    sut.favoritesAction.bind(to: articleToManage).disposed(by: disposeBag)
                    
                    sut.favoritesAction.onNext(article)
                    
                    scheduler.start()
                }
                
                it("should return article that needs to be managed") {
                    expect(articleToManage.events).to(equal([.next(0, article)]))
                }
                
                it("should update article favorite state") {
                    
                }
            }
        }
    }
}
