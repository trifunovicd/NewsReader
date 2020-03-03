//
//  ArticleRequest.swift
//  NewsReader
//
//  Created by Internship on 25/02/2020.
//  Copyright © 2020 Internship. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

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
    
    func getArticles () -> Observable<[ArticleDetails]> {
        
        return Observable.create { observer in
            
            let request = AF.request(self.resourceURL).validate().responseJSON { response in
                guard let jsonData = response.data else {
                    observer.onError(ArticleError.noDataAvailable)
                    return
                }
                
                do{
                    let decoder = JSONDecoder()
                    let articlesResponse = try decoder.decode(Articles.self, from: jsonData)
                    let articleDetails = articlesResponse.articles
                    observer.onNext(articleDetails)
                    observer.onCompleted()
                }
                catch{
                    observer.onError(ArticleError.canNotProcessData)
                }
            }
            
            return Disposables.create{
                request.cancel()
            }
        }
    }
}
