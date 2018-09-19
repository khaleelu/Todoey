//
//  Item.swift
//  Todoey
//
//  Created by Khalid Adam on 9/19/18.
//  Copyright © 2018 Khalid Adam. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title:String = ""
    @objc dynamic var done:Bool = false
    @objc dynamic var dateCreated:Date?
    
    // creating relationships
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
