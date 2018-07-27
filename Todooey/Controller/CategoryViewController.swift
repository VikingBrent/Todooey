//
//  CategoryViewController.swift
//  Todooey
//
//  Created by Brent Adams on 7/27/18.
//  Copyright © 2018 Brent Adams. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    //Array to hold categories
    var categoryArray = [Category]()
    
    //Create context to work with Core Data
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //display the existing categories from the database when the view loads
        loadCategories()
        
    }

    //MARK: - TableView DataSource Methods - Display all categories inside the Persistant Container
    
    //sets the number of cells based on items in the categoryArray
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    //Get the content for the created cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //constant to hold the tableView cell object
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        //constant to hold the category data for the current index row
        let category = categoryArray[indexPath.row]
        
        //Assign the category item's data to the cell's text property
        cell.textLabel?.text = category.name
        
        //return the cell object
        return cell
    }
    
    //MARK: - TableView Delegate Methods - What Should happen when a cell is clicked in the Category View
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "GoToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationViewController = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationViewController.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    //MARK: - Data Manipulation Methods (CRUD - save data & load data)
    
    //Save a new Category to context - try to save, throw error if unable
    func saveCategories() {
        do {
            try context.save()
        } catch {
            print("Error saving category \(error)")
        }
        
        //reload the Category tableView after saving the data
        self.tableView.reloadData()
    }
    
    //load Categories from a request, defaults to show all entries in categoryArray
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest() ) {
        
        //Load the categories - try to load, throw an error if unable
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("Error fetching categories \(error)")
        }
        
        //reload the Category tableView after fetching the data
        tableView.reloadData()
    }
    
    //MARK: - Add New Categories - Using the addButton
    
    //When the + button is clicked, display an alert with text field prompting user for the Category name
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        //variable to hold the UITextField to display in the alert box
        var textField = UITextField()
        
        //constant to hold a UIAlertController object with preferences for how the alert is styled
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        //constant to store the alert action button and its preferences
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            //Closure - defines what happens with the "Add Category" button is clicked
            
            //Constant to hold new Category - move it to the context so it can later be saved to the database
            let newCategory = Category(context: self.context)
            
            //set name for new Category
            newCategory.name = textField.text!
            
            //append new Category to categoryArray
            self.categoryArray.append(newCategory)
            
            self.saveCategories()
        }
        
        //Add textField to alert object
        alert.addTextField { (alertTextField) in
            //set placeholder text
            alertTextField.placeholder = "Add a new Category"
            
            //assign to UITextField object
            textField = alertTextField
            
        }
        
        //assign the alert action button to the alert
        alert.addAction(action)
        
        //display the alert with style preferences
        present(alert, animated: true, completion: nil)
    }
    
    
}
