//
//  WebViewViewModel.swift
//  NewsReader
//
//  Created by Internship on 18/03/2020.
//  Copyright © 2020 Internship. All rights reserved.
//

import Foundation
import RxSwift

class WebViewViewModel {
    
    //MARK: Properties
    private let url: URL?
    let loadArticle = PublishSubject<URL>()
    
    init(url: String) {
        self.url = URL(string: url)
    }
    
    func loadNews() {
        if let url = url {
            loadArticle.onNext(url)
        }
    }
}
