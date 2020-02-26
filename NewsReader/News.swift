//
//  News.swift
//  NewsReader
//
//  Created by Internship on 25/02/2020.
//  Copyright © 2020 Internship. All rights reserved.
//

import Foundation

struct Articles: Decodable {
    var articles: [ArticleDetails]
}

struct ArticleDetails: Decodable {
    var title: String
    var description: String
    var url: String
    var urlToImage: String
}
