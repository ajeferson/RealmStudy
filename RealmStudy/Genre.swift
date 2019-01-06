//
//  Genre.swift
//  RealmStudy
//
//  Created by Alan Jeferson on 1/6/19.
//  Copyright © 2019 Alan Jeferson. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class Genre: Object {
  @objc dynamic var name = ""
  let code = RealmOptional<Int>()
  
  override static func primaryKey() -> String? {
    return "code"
  }
  
  init(name: String, code: Int?) {
    super.init()
    self.name = name
    self.code.value = code
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
