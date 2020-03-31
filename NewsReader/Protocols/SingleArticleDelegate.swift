//
//  SingleArticleDelegate.swift
//  NewsReader
//
//  Created by Internship on 30/03/2020.
//  Copyright © 2020 Internship. All rights reserved.
//

import Foundation

protocol SingleArticleDelegate: AnyObject {
    func openSingleArticle(articles: [News], index: Int)
}
