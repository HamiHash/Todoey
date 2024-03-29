//
//  Item.swift
//  Todoey
//
//  Created by Hamed Hashemi on 7/23/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var date: Date?
    var partntCategory = LinkingObjects(fromType: Category.self, property: "items")
}
