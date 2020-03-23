//
//  ArticlePreview.swift
//  NewsReader
//
//  Created by Internship on 17/03/2020.
//  Copyright © 2020 Internship. All rights reserved.
//

import Foundation

class ArticlePreview: Equatable{
    static func == (lhs: ArticlePreview, rhs: ArticlePreview) -> Bool {
        return lhs.title == rhs.title && lhs.url == rhs.url && lhs.urlToImage == rhs.urlToImage && lhs.isSelected == rhs.isSelected
    }
    
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
