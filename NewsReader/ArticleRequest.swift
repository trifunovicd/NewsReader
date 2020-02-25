//
//  ArticleRequest.swift
//  NewsReader
//
//  Created by Internship on 25/02/2020.
//  Copyright © 2020 Internship. All rights reserved.
//

import Foundation

enum ArticleError: Error {
    case noDataAvailable
    case canNotProcessData
}

struct ArticleRequest {
    let resourceURL: URL
    
    let resourceString = "https://newsapi.org/v1/articles?source=bbc-news&sortBy=top&apiKey=6946d0c07a1c4555a4186bfcade76398"
    
    init() {
        guard let resourceURL = URL(string: resourceString) else {fatalError()}
        self.resourceURL = resourceURL
    }
    
    func getArticles (completion: @escaping(Result<[ArticleDetails], ArticleError>) -> Void){
        let dataTask = URLSession.shared.dataTask(with: resourceURL){data,_,_ in
            guard let jsonData = data else {
                completion(.failure(.noDataAvailable))
                return
            }
            
            do{
                let decoder = JSONDecoder()
                let articlesResponse = try decoder.decode(Articles.self, from: jsonData)
                let articleDetails = articlesResponse.articles
                completion(.success(articleDetails))
            }
            catch{
                completion(.failure(.canNotProcessData))
            }
        }
        
        dataTask.resume()
    }
}
