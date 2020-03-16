//
//  News.swift
//  NewsReader
//
//  Created by Internship on 25/02/2020.
//  Copyright © 2020 Internship. All rights reserved.
//

import Foundation
import RealmSwift

class Articles: Object, Codable {
    var articles: [ArticleDetails]
}

class ArticleDetails: Object, Codable {
    @objc dynamic var title: String
    @objc dynamic var article_description: String
    @objc dynamic var url: String
    @objc dynamic var urlToImage: String
    @objc dynamic var dateSaved: Date?
    
    private enum CodingKeys: String, CodingKey {
        case title, article_description = "description", url, urlToImage
    }
}
