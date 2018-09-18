//
//  Data.swift
//  Todoey
//
//  Created by Khalid Adam on 9/18/18.
//  Copyright © 2018 Khalid Adam. All rights reserved.
//

import Foundation
import RealmSwift

class Data: Object {
    // dynamic is declaration modifier
    // dynamic dispatch
    // can be monitored for change while the app is running. allows realm to dynamically update the change in the database
    @objc dynamic var name:String = ""
    @objc dynamic var age:Int = 0
}
