//
//  WebViewDelegate.swift
//  NewsReader
//
//  Created by Internship on 30/03/2020.
//  Copyright © 2020 Internship. All rights reserved.
//

import Foundation

protocol WebViewDelegate: AnyObject {
    func openInBrowser(articleUrl: String)
}
