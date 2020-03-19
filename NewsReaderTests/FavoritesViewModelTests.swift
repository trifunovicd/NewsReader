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
@testable import NewsReader

class FavoritesViewModelTests: QuickSpec {
    override func spec() {
        describe("FavoritesViewModel"){
            var sut: FavoritesViewModel!
            var disposeBag: DisposeBag!
            
            beforeEach {
                sut = FavoritesViewModel()
                disposeBag = DisposeBag()
                
                sut.bindFetchFavorites().disposed(by: disposeBag)
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
                
                it("should get preview articles") {
                    expect(sut.articlesPreview.value.count).to(beGreaterThanOrEqualTo(0))
                }
                
                it("should get all favorites articles") {
                    expect(sut.favorites.value.count).to(beGreaterThanOrEqualTo(0))
                }
            }
            
        }
    }
}
