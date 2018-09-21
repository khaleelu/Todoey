//
//  ViewController.swift
//  Todoey
//
//  Created by Khalid Adam on 9/13/18.
//  Copyright © 2018 Khalid Adam. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    
    var itemArray: Results<Item>?
    var realm = try! Realm()
    
    var selectedCategory:Category? {
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        tableView.tableHeaderView = nil
        self.title = selectedCategory?.name
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let navBar = navigationController?.navigationBar
        navBar?.tintColor = ContrastColorOf(HexColor("3A4157")!, returnFlat: true)
    }

    //MARK:- TableView DataSource Methods
    // func that adds data into the table cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = itemArray?[indexPath.row] {
            // ternary operator ==>
            // value = condition ? valueIfTrue : valueIfFalse
            
            cell.accessoryType = item.done ? .checkmark : .none
            
            cell.textLabel?.text = item.title

        } else {
            cell.textLabel?.text = "No items added"
        }
        
        cell.textLabel?.font = UIFont(name: "HelveticaNeue-UltraLight", size: 25)
        
        return cell
    }
    
    // func that counts the number of items and creates that many table cells
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray?.count ?? 1
    }
    
    //MARK:- TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = itemArray?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                    // realm.delete(item)
                }
            } catch {
                print("Error saving done status, \(error)")
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
        
    }
    
    //MARK:- Add new items section
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        // creating a textField var
        var textField = UITextField()
        
        // creating an alert when the button is pressed
        let alert = UIAlertController(title: "Add Item", message: "", preferredStyle: .alert)
        
        // what will happen once the user clicks on the add item button on the UIAlert
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving items \(error)")
                }
            }
            self.tableView.reloadData()
        }
        
        // adding a text field to the alert
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        // the method that is called when the add button is pressed on the UIAlert
        alert.addAction(action)
        
        // presenting the alert to the user
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK:- Model Manipulation Methods
    
    func saveItems(item: Item) {
        
        do {
            try realm.write {
                realm.add(item)
            }
        } catch {
            print("error saving context, \(error)")
        }
        
        // reloading the table view cells
        tableView.reloadData()
    }
    
    func loadItems() {
        
        itemArray = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let itemForDeletion = self.itemArray?[indexPath.row]{
            do {
                try self.realm.write {
                    self.realm.delete(itemForDeletion)
                }
            } catch {
                print("Error deleting category, \(error)")
            }
        }
    }
}

//MARK:- Search bar functionality
extension TodoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        itemArray = itemArray?.filter("title CONTAINS %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // showing all items once search is cancelled
        if searchBar.text?.count == 0 {
            loadItems()

            // code being run in the foreground
            DispatchQueue.main.async {
                // dismissing the keyboard and search bar
                searchBar.resignFirstResponder()
            }
        }
    }
}
