//
//  ViewController.swift
//  RealmStudy
//
//  Created by Alan Jeferson on 12/26/18.
//  Copyright © 2018 Alan Jeferson. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {

  private var books = [Book]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    seed()
  }
  
  private func seed() {
    do {
      let realm = try Realm()
      
      guard realm.objects(Book.self).count == 0 else {
        print("No seed required")
        return
      }
      
      try realm.write {
        let book1 = Book()
        book1.name = "Game of Thrones"
        book1.releaseDate = date(from: "1997/12/01")!
        realm.add(book1)
      }
      
      print("Seed successfully performed!")
    } catch {
      print("Could not seed with error: \(error)")
    }
  }
  
  private func date(from string: String) -> Date? {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy/mm/dd"
    return formatter.date(from: string)
  }
}

