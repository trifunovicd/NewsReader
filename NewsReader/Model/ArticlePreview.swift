//
//  ArticlePreview.swift
//  NewsReader
//
//  Created by Internship on 17/03/2020.
//  Copyright © 2020 Internship. All rights reserved.
//

import Foundation

class ArticlePreview {
    var title: String
    var url: String
    var urlToImage: String
    var isSelected: Bool
    
    init(title: String, url: String, urlToImage: String, isSelected: Bool) {
        self.title = title
        self.url = url
        self.urlToImage = urlToImage
        self.isSelected = isSelected
    }
}
