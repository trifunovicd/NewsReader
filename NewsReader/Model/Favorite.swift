//
//  Favorite.swift
//  NewsReader
//
//  Created by Internship on 16/03/2020.
//  Copyright © 2020 Internship. All rights reserved.
//

import Foundation
import RealmSwift

class Favorite: Object {
    @objc dynamic var url: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var urlToImage: String = ""
    @objc dynamic var isSelected: Bool = false
}
