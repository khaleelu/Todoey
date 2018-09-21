//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by Khalid Adam on 9/20/18.
//  Copyright © 2018 Khalid Adam. All rights reserved.
//

import UIKit
import SwipeCellKit
import ChameleonFramework

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {
//    var defaultOptions = SwipeOptions()
//    var isSwipeRightEnabled = true
//    var buttonDisplayMode: ButtonDisplayMode = .titleAndImage
//    var buttonStyle: ButtonStyle = .backgroundColor
//    var usesTallCells = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        tableView.separatorStyle = .none
        self.setStatusBarStyle(UIStatusBarStyleContrast)
        self.navigationController?.hidesNavigationBarHairline = true
        tableView.rowHeight = 80.0

    }
    
    // TableView DataSource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        
        cell.delegate = self
        
        cell.textLabel?.textColor = UIColor.white
        cell.backgroundColor = UIColor.clear

        cell.textLabel?.font = UIFont(name: "HelveticaNeue-UltraLight", size: 35)
        
        return cell
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .default, title: "Remove") { action, indexPath in
            // handle action by updating model with deletion
            self.updateModel(at: indexPath)
        }
        
        deleteAction.transitionDelegate = ScaleTransition.default
        deleteAction.backgroundColor = UIColor(hexString: "3A4157")
        deleteAction.textColor = .none
        // deleteAction.font = UIFont(name: "HelveticaNeue-UltraLight", size: 12)
        deleteAction.fulfill(with: ExpansionFulfillmentStyle.delete)
        deleteAction.highlightedBackgroundColor = .clear
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
    }
        
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        options.expansionDelegate = ScaleAndAlphaExpansion.default

        return options
    }
    
    func updateModel(at indexPath:IndexPath){
        // Update data model
    }
}
