//
//  WebViewViewModelTests.swift
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

class WebViewViewModelTests: QuickSpec {
    override func spec() {
        describe("WebViewViewModel"){
            var sut: WebViewViewModel!
            var disposeBag: DisposeBag!
            var scheduler: TestScheduler!
            var result: TestableObserver<URL>!
            var url: URL!
            
            
            beforeEach {
                sut = WebViewViewModel(url: "https://www.google.com/")
                disposeBag = DisposeBag()
                scheduler = TestScheduler(initialClock: 0)
                result = scheduler.createObserver(URL.self)
                url = URL(string: "https://www.google.com/")
            }
            
            
            context("on load") {
                beforeEach {
                    sut.loadArticle.bind(to: result).disposed(by: disposeBag)
                    sut.loadNews()
                }
                
                it("should open article from url") {
                    expect(result.events).to(equal([.next(0, url)]))
                }
            }
        }
    }
}
