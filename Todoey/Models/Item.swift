//
//  Item.swift
//  Todoey
//
//  Created by Luke Tchang on 8/8/19.
//  Copyright © 2019 Luke Tchang. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object{
    @objc dynamic var title: String = ""
    @objc dynamic var checked: Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
