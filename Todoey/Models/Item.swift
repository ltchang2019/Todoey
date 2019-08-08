//
//  Item.swift
//  Todoey
//
//  Created by Luke Tchang on 8/6/19.
//  Copyright © 2019 Luke Tchang. All rights reserved.
//

import Foundation

class Item: Encodable, Decodable{
    var title: String = ""
    var checked: Bool = false
}
