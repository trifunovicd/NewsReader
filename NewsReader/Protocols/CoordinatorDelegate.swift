//
//  CoordinatorDelegate.swift
//  NewsReader
//
//  Created by Internship on 31/03/2020.
//  Copyright © 2020 Internship. All rights reserved.
//

import Foundation

protocol CoordinatorDelegate: AnyObject {
    func childDidFinish(child: Coordinator)
}
