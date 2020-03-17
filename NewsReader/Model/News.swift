//
//  News.swift
//  NewsReader
//
//  Created by Internship on 17/03/2020.
//  Copyright © 2020 Internship. All rights reserved.
//

import Foundation

protocol News {
    var title: String { get set }
    var articleDescription: String { get set }
    var url: String { get set }
    var urlToImage: String { get set }
}
