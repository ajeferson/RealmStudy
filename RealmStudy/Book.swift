//
//  Book.swift
//  RealmStudy
//
//  Created by Alan Jeferson on 1/6/19.
//  Copyright © 2019 Alan Jeferson. All rights reserved.
//

import Foundation
import RealmSwift

class Book: Object {
  @objc dynamic var name = ""
  @objc dynamic var sinopsis = ""
  @objc dynamic var releaseDate = Date()
}
