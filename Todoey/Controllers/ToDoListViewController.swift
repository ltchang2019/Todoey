//
//  ViewController.swift
//  Todoey
//
//  Created by Luke Tchang on 8/5/19.
//  Copyright © 2019 Luke Tchang. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController {

    let realm = try! Realm()
    
    var toDoItems: Results<Item>?
    var selectedCategory: Category?{
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

//RETURN NUMBER OF CELLS TO START
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRows = toDoItems?.count ?? 1
        return numberOfRows
    }
//CELL FOR ROW METHOD
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = toDoItems?[indexPath.row]{
            cell.textLabel?.text = item.title
            cell.accessoryType = item.checked ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No items added yet"
        }
    
        return cell
    }
    
//DID SELECT CELL METHOD
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if let item = toDoItems?[indexPath.row]{
            do{
                try realm.write {
                   item.checked = !item.checked
                }
            } catch {
                print("Error checking off item \(error)")
            }
            
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
//NEW ITEM BUTTON AND USING ALERTS TO ADD STUFF
    @IBAction func addItemButton(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            if let currentCategory = self.selectedCategory{
                do{
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                        //ADD NEW ITEM UNDER CURRENT CATEGORY'S ITEM'S LIST (REVERSE RELATIONSHP)
                    }
                } catch {
                    print("Error adding item \(error)")
                }
            }
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
//SAVE ITEMS IN COREDATA MODEL
    func saveItems(item: Item, category: Category){
        do{
            try realm.write{
                realm.add(item)
                category.items.append(item)
            }
        } catch {
           print("Error saving items \(error)")
        }
        tableView.reloadData()
    }
    
//LOADS ITEMS FROM COREDATA DATAMODEL
    func loadItems(){
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
    }
}

//SEARCHBAR METHODS
extension ToDoListViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text!.count == 0 {
            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

