//
//  Category.swift
//  Todoey
//
//  Created by Khalid Adam on 9/19/18.
//  Copyright © 2018 Khalid Adam. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name:String = ""
    
    // creating relationships
    let items = List<Item>()
    
}
