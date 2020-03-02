//
//  CustomImageView.swift
//  NewsReader
//
//  Created by Internship on 25/02/2020.
//  Copyright © 2020 Internship. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

class CustomImageView : UIImageView {
    
    var imageUrlString: String?
    
    func loadImageUsingUrlString(urlString: String) {
        
        imageUrlString = urlString
        
        let url = URL(string: urlString)
        image = nil
        
        if let imageFromCache = imageCache.object(forKey: urlString as NSString) as? UIImage  {
            self.image = imageFromCache
            return
        }
        
        URLSession.shared.dataTask(with: url!, completionHandler: {data,_,error in
            
            if error != nil {
                print(error!)
                return
            }
            
            DispatchQueue.main.async {
                let imageToCache = UIImage(data: data!)
                
                if self.imageUrlString == urlString {
                    self.image = imageToCache
                }
                
                imageCache.setObject(imageToCache!, forKey: urlString as NSString)
            }
            
        }).resume()
    }
}
