//
//  Book.swift
//  RealmStudy
//
//  Created by Alan Jeferson on 1/6/19.
//  Copyright © 2019 Alan Jeferson. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class Book: Object {
  @objc dynamic var id = 0
  @objc dynamic var name = ""
  @objc dynamic var sinopsis = ""
  @objc dynamic var releaseDate = Date()
  @objc dynamic var author: Author?
  @objc dynamic var genre: Genre?
  let code = RealmOptional<Int>()
  var tempId = 0
  
  // Read only properties are automatically ignored
  var year: Int {
    return 0
  }
  
  override static func primaryKey() -> String? {
    return "id"
  }
  
  override static func indexedProperties() -> [String] {
    return ["code"]
  }
  
  override static func ignoredProperties() -> [String] {
    return ["tempId"]
  }
  
  init(id: Int = 0,
       name: String = "",
       sinopsis: String = "",
       releaseDate: Date = Date(),
       author: Author? = nil,
       genre: Genre? = nil) {
    super.init()
    self.id = id
    self.name = name
    self.sinopsis = sinopsis
    self.releaseDate = releaseDate
    self.author = author
    self.genre = genre
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
