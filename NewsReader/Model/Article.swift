//
//  Article.swift
//  NewsReader
//
//  Created by Internship on 25/02/2020.
//  Copyright © 2020 Internship. All rights reserved.
//

import Foundation
import RealmSwift

class Articles: Object, Codable {
    var articles: [ArticleDetails] = []
}

class ArticleDetails: Object, News, Codable {
    @objc dynamic var title: String
    @objc dynamic var articleDescription: String
    @objc dynamic var url: String
    @objc dynamic var urlToImage: String
    @objc dynamic var localStored: Bool = false
    
    private enum CodingKeys: String, CodingKey {
        case title, articleDescription = "description", url, urlToImage
    }
    
//    convenience init(title: String, articleDescription: String, url: String, urlToImage: String, localStored: Bool) {
//
//        self.title = title
//        self.articleDescription = articleDescription
//        self.url = url
//        self.urlToImage = urlToImage
//        self.localStored = localStored
//    }
}
