//
//  SingleArticleViewModel.swift
//  NewsReader
//
//  Created by Internship on 13/03/2020.
//  Copyright © 2020 Internship. All rights reserved.
//

import Foundation
import RxSwift

class SingleArticleViewModel {
    
    //MARK: Properties
    let articles: [ArticleDetails]
    let index: Int
    let scrollToItem = PublishSubject<IndexPath>()
    
    init(articles: [ArticleDetails], index: Int) {
        self.articles = articles
        self.index = index
    }
    
    func scrollToPreselectedItem() {
        let indexPath = IndexPath(row: index, section: 0)
        scrollToItem.onNext(indexPath)
    }
}
