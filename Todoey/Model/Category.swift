//
//  Category.swift
//  Todoey
//
//  Created by Hamed Hashemi on 7/23/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>() // list is for relationship
}
