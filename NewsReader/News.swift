//
//  News.swift
//  NewsReader
//
//  Created by Internship on 25/02/2020.
//  Copyright © 2020 Internship. All rights reserved.
//

import Foundation

class Articles: NSObject, Decodable, NSCoding, NSSecureCoding {
    static var supportsSecureCoding: Bool = true
    
    var articles: [ArticleDetails]
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let NewsArchiveURL = DocumentsDirectory.appendingPathComponent("news")
    static let DateArchiveURL = DocumentsDirectory.appendingPathComponent("date")
    
    //MARK: Types
    struct PropertyKey {
        static let articles = "articles"
    }
    
    //MARK: Initialization
    init?(articles: [ArticleDetails]){
        self.articles = articles
    }
    
    //MARK: NSCoding
    func encode(with coder: NSCoder) {
        coder.encode(articles)
    }
    
    required convenience init?(coder: NSCoder) {
        let articles = coder.decodeObject(forKey: PropertyKey.articles) as! [ArticleDetails]
        
        self.init(articles: articles)
        
    }
}

class ArticleDetails: Decodable {
    var title: String
    var url: String
    var urlToImage: String
}
