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
    setupRealm()
    seed()
    loadBooks()
  }
  
  private func loadBooks() {
    guard let realm = try? Realm() else {
      return
    }
    books = realm.objects(Book.self).map { $0 }
  }
  
  private func setupRealm() {
    var config = Realm.Configuration()
    let configDirectoryUrl = Realm.Configuration.defaultConfiguration.fileURL?.deletingLastPathComponent()
    let configFileUrl = configDirectoryUrl?.appendingPathComponent("RealmStudy.realm")
    config.fileURL = configFileUrl
    config.objectTypes = [Genre.self, Author.self, Book.self]
    config.shouldCompactOnLaunch = { _, _ -> Bool in true } // always compact on launch
    config.deleteRealmIfMigrationNeeded = true
//    config.readOnly = true
//    config.inMemoryIdentifier = "InMemoryRealmStudy"
    Realm.Configuration.defaultConfiguration = config
    print("Realm configuration is at: \(configFileUrl?.absoluteString ?? "")")
  }
  
  private func seed() {
    do {
      let realm = try Realm()
      
      guard realm.objects(Book.self).count == 0 else {
        print("No seed required")
        return
      }
      
      try realm.write {
        let fantasy = Genre(name: "Fantasy", code: 1)
        
        let gameOfThrones = Book(id: 1,
                         name: "Game of Thrones",
                         releaseDate: date(from: "1997/12/01")!,
                         genre: fantasy)
        
        realm.add(gameOfThrones)
        
        assert(gameOfThrones.realm == realm)
      }
      
      print("Seed successfully performed!")
    } catch let error as NSError {
      print("Could not seed with error: \(error.localizedDescription)")
      deleteRealmFiles()
    }
  }
  
  private func deleteRealmFiles() {
    guard let url = try? Realm().configuration.fileURL,
      let realmURL = url else {
      print("Realm configuration has no fileURL")
      return
    }
    let realmURLs = [
      realmURL,
      realmURL.appendingPathExtension("lock"),
      realmURL.appendingPathExtension("note"),
      realmURL.appendingPathExtension("management")
    ]
    for URL in realmURLs {
      do {
        try FileManager.default.removeItem(at: URL)
      } catch let error as NSError {
        print("Error ocurred when deleting realm file: \(error)")
      }
    }
  }
  
  private func date(from string: String) -> Date? {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy/mm/dd"
    return formatter.date(from: string)
  }
  
  private func presentUpdateBookInitialAlert() {
    let alert = UIAlertController(title: "Update Book", message: "Book's ID", preferredStyle: .alert)
    alert.addTextField(configurationHandler: nil)
    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [weak self] _ in
      guard let strongSelf = self,
        let idString = alert.textFields?.first?.text,
        let id = Int(idString) else {
          return
      }
      strongSelf.presentUpdateBookSecondAlert(id)
    }))
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    present(alert, animated: true, completion: nil)
  }
  
  private func presentUpdateBookSecondAlert(_ id: Int) {
    let alert = UIAlertController(title: "Update Book", message: "Book's new name", preferredStyle: .alert)
    alert.addTextField(configurationHandler: nil)
    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [weak self] _ in
      guard let strongSelf = self,
        let newName = alert.textFields?.first?.text else {
          return
      }
      DispatchQueue.global(qos: .background).async {
        guard let realm = try? Realm(),
          let book = realm.object(ofType: Book.self, forPrimaryKey: id) else {
            return
        }
        do {
          try realm.write {
            book.name = newName
          }
          DispatchQueue.main.async {
            strongSelf.tableView?.reloadData()
          }
        } catch {
          print(error)
        }
      }
    }))
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    present(alert, animated: true, completion: nil)
  }
  
  @IBAction func didTouchUpdateButton(_ sender: UIBarButtonItem) {
    presentUpdateBookInitialAlert()
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
