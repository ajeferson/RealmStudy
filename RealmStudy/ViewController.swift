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
  @IBOutlet var tableView: UITableView?

  private var books = [Book]() {
    didSet {
      tableView?.reloadData()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    seed()
    loadBooks()
  }
  
  private func loadBooks() {
    guard let realm = try? Realm() else {
      return
    }
    books = realm.objects(Book.self).map { $0 }
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

extension ViewController: UITableViewDataSource {
  var formatter: DateFormatter {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .long
    return dateFormatter
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return books.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
    let book = books[indexPath.row]
    cell.textLabel?.text = book.name
    cell.detailTextLabel?.text = formatter.string(from: book.releaseDate)
    return cell
  }
}
