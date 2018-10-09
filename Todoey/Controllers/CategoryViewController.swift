//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Khalid Adam on 9/17/18.
//  Copyright © 2018 Khalid Adam. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var selectedRowIndex = -1
    
    var categoryArray: Results<Category>?
    var itemArray: Results<Item>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        
        // registering custom cell
        tableView.register(UINib(nibName: "CategoryCell", bundle: nil), forCellReuseIdentifier: "customCategoryCell")

    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        // nil coalescing operator; if nil then use 1
        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == selectedRowIndex {
            return 90 //Expanded
        }
        return 50 //Not expanded
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // inheriting from superclass
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCategoryCell", for: indexPath) as! CustomCategoryCell
        
        // configure the cell...
        cell.cellTitle?.text = categoryArray?[indexPath.row].name ?? "No categories added"
        cell.cellSubTitle?.text = itemArray?[indexPath.row].title ?? "No items"
        
        return cell
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        // creating a textField var
        var textField = UITextField()
        
        // creating an alert when the button is pressed
        let alert = UIAlertController(title: "Add Category", message: "", preferredStyle: .alert)
        
        // what will happen once the user clicks on the add item button on the UIAlert
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            // creating a new object as an item
            let newCategory = Category()
            newCategory.name = textField.text!
            
            // updating the persistent data constant
            // self.defaults.set(self.itemArray, forKey: "TodoListArray")
            self.saveCategories(category: newCategory)
            
        }
        
        // adding a text field to the alert
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        
        // the method that is called when the add button is pressed on the UIAlert
        alert.addAction(action)
        
        // presenting the alert to the user
        present(alert, animated: true, completion: nil)
    }
    
    //MARK:- TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // performSegue(withIdentifier: "goToItems", sender: self)
        if selectedRowIndex == indexPath.row {
            selectedRowIndex = -1
        } else {
            selectedRowIndex = indexPath.row
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        // grabbing the index path for selected row
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
    }
    
    //MARK:- Data Manipulation Methods
    func saveCategories(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("error saving context, \(error)")
        }
        
        // reloading the table view cells
        tableView.reloadData()
    }
    
    func loadCategories() {
        
        categoryArray = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categoryArray?[indexPath.row]{
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("Error deleting category, \(error)")
            }
        }
    }
}


