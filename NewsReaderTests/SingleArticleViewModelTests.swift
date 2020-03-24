//
//  SingleArticleViewModelTests.swift
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
@testable import NewsReader

class SingleArticleViewModelTests: QuickSpec {
    override func spec() {
        describe("SingleArticleViewModel"){
            var sut: SingleArticleViewModel!
            var disposeBag: DisposeBag!
            var scheduler: TestScheduler!
            var result: TestableObserver<IndexPath>!
            
            
            beforeEach {
                sut = SingleArticleViewModel(articles: [], index: 1)
                disposeBag = DisposeBag()
                scheduler = TestScheduler(initialClock: 0)
                result = scheduler.createObserver(IndexPath.self)
            }
            
            
            context("on load") {
                beforeEach {
                    sut.scrollToItem.bind(to: result).disposed(by: disposeBag)
                    sut.scrollToPreselectedItem()
                }
                
                it("should scroll to preselected item") {
                    expect(result.events).to(equal([.next(0, IndexPath(row: 1, section: 0))]))
                }
            }
        }
    }
}
