//
//  Author.swift
//  RealmStudy
//
//  Created by Alan Jeferson on 1/6/19.
//  Copyright © 2019 Alan Jeferson. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class Author: Object {
  @objc dynamic var id = 0
  @objc dynamic var name = ""
  let books = List<Book>()
  
  override static func primaryKey() -> String? {
    return "id"
  }
  
  init(id: Int, name: String) {
    super.init()
    self.id = id
    self.name = name
  }
  
  required init(value: Any, schema: RLMSchema) {
    super.init(value: value, schema: schema)
  }
  
  required init() {
    super.init()
  }
  
  required init(realm: RLMRealm, schema: RLMObjectSchema) {
    super.init(realm: realm, schema: schema)
  }
}
