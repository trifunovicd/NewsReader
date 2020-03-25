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
            var errorAlert: TestableObserver<Bool>!
            var endRefreshing: TestableObserver<Bool>!
            var articleToManage: TestableObserver<ArticlePreview>!
            var article: ArticlePreview!
            var generalRefresh: RefreshType!
            var networkRefresh: RefreshType!
            var defaults: UserDefaults!
            
            
            beforeEach {
                sut = AllArticlesViewModel(observable: self.getTestArticles())
                disposeBag = DisposeBag()
                scheduler = TestScheduler(initialClock: 0)
                result = scheduler.createObserver([ArticlePreview].self)
                errorAlert = scheduler.createObserver(Bool.self)
                endRefreshing = scheduler.createObserver(Bool.self)
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
                
                defaults = UserDefaults.standard
                defaults.removeObject(forKey: "Date")
                
                sut.articlesPreview.bind(to: result).disposed(by: disposeBag)

                sut.alertOfError.bind(to: errorAlert).disposed(by: disposeBag)

                sut.endRefreshing.bind(to: endRefreshing).disposed(by: disposeBag)
                
            }
            
            
            context("on local fetch") {
                context("if error occurred") {
                    beforeEach {
                        sut.bindFetch(observable: self.getError(forceUpdate:), scheduler: scheduler).disposed(by: disposeBag)

                        sut.reloadRequest.onNext(generalRefresh)
                        scheduler.start()
                    }

                    it("should end refreshing") {
                        expect(endRefreshing.events).to(equal([.next(1, true)]))
                    }

                    it("should alert of error") {
                        expect(errorAlert.events).to(equal([.next(1, true)]))
                    }

                    it("should show empty list of preview articles") {
                        expect(result.events).to(equal([.next(0, [])]))
                    }
                }


                context("if fetch was successful") {
                    beforeEach {
                        do{
                            let path = Bundle.main.path(forResource: "localArticles", ofType: "json")
                            let jsonData = try Data(contentsOf: URL(fileURLWithPath: path!), options: .mappedIfSafe)

                            let decoder = JSONDecoder()
                            let response = try decoder.decode(Articles.self, from: jsonData)

                            let realm = try Realm()

                            try realm.write{
                                realm.add(response.articles)
                            }
                        }
                        catch{
                            fail("Expecting to get failure")
                        }

                        defaults.set(Date(), forKey: "Date")

                        sut.bindFetch(observable: sut.getDataObservable(forceUpdate:), scheduler: scheduler).disposed(by: disposeBag)

                        sut.reloadRequest.onNext(generalRefresh)
                        scheduler.start()
                    }

                    it("should end refreshing") {
                        expect(endRefreshing.events).to(equal([.next(1, true)]))
                    }

                    it("should show preview of articles") {
                        expect(result.events.last?.value.element?.count).to(equal(10))
                    }
                }
            }

            
            context("on online fetch") {
                context("if error occurred") {
                    beforeEach {
                        sut.bindFetch(observable: self.getError(forceUpdate:), scheduler: scheduler).disposed(by: disposeBag)

                        sut.reloadRequest.onNext(networkRefresh)
                        scheduler.start()

                    }

                    it("should end refreshing") {
                        expect(endRefreshing.events).to(equal([.next(1, true)]))
                    }

                    it("should alert of error") {
                        expect(errorAlert.events).to(equal([.next(1, true)]))
                    }

                    it("should show empty list of preview articles") {
                        expect(result.events).to(equal([.next(0, [])]))
                    }
                }


                context("if fetch was successful") {
                    beforeEach {
                        sut.bindFetch(observable: sut.getDataObservable(forceUpdate:), scheduler: scheduler).disposed(by: disposeBag)

                        sut.reloadRequest.onNext(networkRefresh)
                        scheduler.start()

                    }

                    it("should end refreshing") {
                        expect(endRefreshing.events).to(equal([.next(1, true)]))
                    }

                    it("should show preview of articles") { expect(result.events.last?.value.element?.count).to(equal(10))
                    }
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
            }
        }
    }
    
    
    private func getError(forceUpdate: RefreshType) -> Observable<Result<([ArticlePreview], Articles, Bool), Error>> {
        
        let result = Result<([ArticlePreview], Articles, Bool),Error>.failure(DataError.noDataAvailable)
        return Observable.just(result)
    }
    
    private func getTestArticles() -> Observable<Articles> {
        return Observable.create { observer in
            
            do {
                let path = Bundle.main.path(forResource: "localArticles", ofType: "json")
                let jsonData = try Data(contentsOf: URL(fileURLWithPath: path!), options: .mappedIfSafe)
                
                let decoder = JSONDecoder()
                let response = try decoder.decode(Articles.self, from: jsonData)
                
                observer.onNext(response)
                observer.onCompleted()
                
            } catch {
                observer.onError(DataError.canNotProcessData)
            }
            
            return Disposables.create()
        }
    }
}
