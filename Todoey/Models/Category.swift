//
//  Category.swift
//  Todoey
//
//  Created by Luke Tchang on 8/8/19.
//  Copyright © 2019 Luke Tchang. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object{
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
