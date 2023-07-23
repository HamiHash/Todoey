import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "no categories added yet"
        return cell
    }
    
    // MARK: - TableView Delegates
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController //  to target the TodoListViewCrontroller
        // get the selected category from "selected row" and then setting it to a property in TodoListTableView
        if let indexItem = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexItem.row]
        }
    }
    
    //MARK: - Add New Category
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        // Creating the alert
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        
        // Adding the textfield to alert
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Category"
            textField = alertTextField // making it available in outer scope
        }
        
        // Creating the actions
        let doneAction = UIAlertAction(title: "Done", style: .default) { (action) in
            // what will happen once the user clicks the Done button
            
            // adding the text to our array if it is not empty
            if textField.text == "" {
                return
            } else {
                let enteredText = String(textField.text!)
                // Realm
                let newItem = Category()
                newItem.name = enteredText
                self.saveData(category: newItem)
            }
            
            self.tableView.reloadData() // refreshing the tableView
            
            // setting the new array to userDefaults (we are not using userDfault for this anymore)
            // self.defaults.set(self.itemArray, forKey: "TodoListItems")
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { action in
            // what will happen once the user clicks the cancel button
        }
        
        alert.addAction(doneAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil) // presenting the alert
    }
    
    func saveData(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("error while saving category: \(error)")
        }
        tableView.reloadData()
    }
    
    func loadData() {
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
}
