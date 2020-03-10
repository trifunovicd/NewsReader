//
//  Request.swift
//  NewsReader
//
//  Created by Internship on 25/02/2020.
//  Copyright © 2020 Internship. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

enum DataError: Error {
    case noDataAvailable
    case canNotProcessData
}

enum Urls: String {
    case articleUrl = "https://newsapi.org/v1/articles?source=bbc-news&sortBy=top&apiKey=6946d0c07a1c4555a4186bfcade76398"
}

func getRequest<Data: Codable> (url: String) -> Observable<Data> {
    
    return Observable.create { observer in
        
        let request = AF.request(url).validate().responseJSON { response in
            guard let jsonData = response.data else {
                observer.onError(DataError.noDataAvailable)
                return
            }
            
            do{
                let decoder = JSONDecoder()
                let response = try decoder.decode(Data.self, from: jsonData)

                observer.onNext(response)
                observer.onCompleted()
            }
            catch{
                observer.onError(DataError.canNotProcessData)
            }
        }
        
        return Disposables.create{
            request.cancel()
        }
    }
}

