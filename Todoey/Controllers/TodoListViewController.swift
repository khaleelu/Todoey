//
//  ViewController.swift
//  Todoey
//
//  Created by Khalid Adam on 9/13/18.
//  Copyright © 2018 Khalid Adam. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    var selectedCategory:Category? {
        didSet {
            loadItems()
        }
    }
    
    // creating a constant for setting persistent data
    // let defaults = UserDefaults.standard
    
    // this complicated line creates a new PLIST file in the document directory of the application
    // in it is stored the to-do items, and the check marks (whether done or not)
    // user defaults aren't used because they are meant only for small amounts of data
    
    // that long nonsense is to create an object out of AppDelegate class
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        tableView.separatorStyle = .none
        // tableView.tableHeaderView = searchBarController.searchBar
        
        // tableView.setContentOffset(CGPoint.init(x: 0, y: 44), animated: false)
        
        // self.view.addSubview(tableView)
        
        tableView.tableHeaderView = nil

        
    }

    //MARK:- TableView DataSource Methods
    // func that adds data into the table cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        // ternary operator ==>
        // value = condition ? valueIfTrue : valueIfFalse
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        cell.textLabel?.text = item.title
        
        return cell
    }
    
    // clearing the background colour of the cell
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    
    // func that counts the number of items and creates that many table cells
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    //MARK:- TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // print(itemArray[indexPath.row])
        
        // itemArray = opposite of itemArray
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        // adding a checkmark when selected, and removing when selected again
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        } else {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
        
    }
    
    //MARK:- Add new items section
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        // creating a textField var
        var textField = UITextField()
        
        // creating an alert when the button is pressed
        let alert = UIAlertController(title: "Add Item", message: "", preferredStyle: .alert)
        
        // what will happen once the user clicks on the add item button on the UIAlert
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            // creating a new object as an item
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            
            // updating the persistent data constant
            // self.defaults.set(self.itemArray, forKey: "TodoListArray")
            self.saveItems()
            
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
    
    func saveItems() {
        
        do {
            try context.save()
        } catch {
            print("error saving context, \(error)")
        }
        
        // reloading the table view cells
        tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        // filtering results based on category
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        // searching after filtering
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        // creating a var to fetch data
        // let request:NSFetchRequest<Item> = Item.fetchRequest()
        
        do {
            // output is an array
            itemArray = try context.fetch(request)
        } catch {
            print("error fetching request, \(error)")
        }
        
        tableView.reloadData()
    }
}

//MARK:- Search bar functionality
extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request:NSFetchRequest<Item> = Item.fetchRequest()
        
        // NSPredicate is a foundation class that specifies how data should be fetched/filtered. is @objc
        // adding the search term to the request
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        // creating a sorting condition: sort by title, in ascending order
        // adding that condition to the request. Note that is says sortDescriptors (plural), because it can have multiple sort options
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        // refreshing the table view
        loadItems(with: request, predicate: predicate)
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



/*
 
 CREATING a new item and saving it
 - first thing is a context, which is an object of AppDelegate, grabbing a reference to the contect
 - context is of type NSPersistentContainer, and conforms to the data model type we create
 - loading the store and gettting ready for use
 - when new items are aded, new object of ITEM type is created, with the attributes form the data model
 - the new object are part of the NSManagedObject, which has all the attributes from the data model
 - the context is the temporary area, where items can be added and removed
 - finally the context is saved and committed to the model
 
*/

/*
 
 READING from the database
 - first create a var that will fetch the data from the DB
 - this var is of the type NSFetchRequest.
    * IMPORTANT: the var has to be explicitly declared as NSFetchRequest<Item>
 
*/

/*
 
 UPDATING new items already done
 - changing the done property by adding a checkmark
 
*/

/*
 
 DELETING an obj from the DB
 - Deletes currently selected row from DB
 - Order matters
 
    context.delete(itemArray[indexPath.row])
    itemArray.remove(at: indexPath.row)
 
 */
