//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Luke Tchang on 8/8/19.
//  Copyright © 2019 Luke Tchang. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var categoryArray: Results<Category>?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
    }
    
    //TABLEVIEW DATASOURCE METHODS (CALLED WHEN TABLEVIEW RELOADED)
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //NIL COALESCING OPERATOR USES ?? (RETURN 1 IF CATEGORYARRAY.COUNT IS NIL)
        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCategory", for: indexPath)
        
        let category = categoryArray?[indexPath.row]
        
        cell.textLabel?.text = category?.name ?? "No categories added yet"
        
        return cell
    }
    
    //TABLEVIEW DELEGATE METHODS
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
//SEGUE TO ITEMS METHODS
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
    }

//ADD IB BUTTON
    @IBAction func addCategoryButton(_ sender: UIBarButtonItem) {
       var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Add Category", style: .default) { (action) in
            do{
                try self.realm.write {
                    let newCategory = Category()
                    newCategory.name = textField.text!
                    self.realm.add(newCategory)
                }
            } catch {
                print("Error adding category \(error)")
            }
            self.tableView.reloadData()
            //RESULTS REALM DATA TYPE IS AUTO UPDATING SO YOU DON'T NEED TO CALL ANY SAVE FUNCTION
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
    }
    

//CORE DATA METHODS
    func save(category: Category){
        do{
            try realm.write {
                
            }
        } catch {
            print("Error saving category \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategories(){
        categoryArray = realm.objects(Category.self)

        tableView.reloadData()
    }
    
}
