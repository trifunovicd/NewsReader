//
//  NewsReaderTests.swift
//  NewsReaderTests
//
//  Created by Internship on 25/02/2020.
//  Copyright © 2020 Internship. All rights reserved.
//

import XCTest
import RxSwift
import RxTest
@testable import NewsReader

class Recorder<T> {
    var items = [T]()
    let bag = DisposeBag()

    func on(arraySubject: PublishSubject<[T]>) {
        arraySubject.subscribe(onNext: { value in
            self.items = value
        }).disposed(by: bag)
    }

    func on(valueSubject: PublishSubject<T>) {
        valueSubject.subscribe(onNext: { value in
            self.items.append(value)
        }).disposed(by: bag)
    }
}

class NewsReaderTests: XCTestCase {
    
    var favoritesViewModel: FavoritesViewModel!
    let bag = DisposeBag()

    override func setUp() {
        super.setUp()
        favoritesViewModel = FavoritesViewModel()
    }

    override func tearDown() {
        favoritesViewModel = nil
        super.tearDown()
    }

//    func testFavoritesRequest() {
//        
//        //Given
//        let count = 6
//        
//        //When
//        favoritesViewModel.bindFetchFavorites().disposed(by: bag)
//        favoritesViewModel.favoritesRequest.onNext(())
//        
//        //Then
//        XCTAssertEqual(favoritesViewModel.articlesPreview.value.count, count)
//    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
