import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categoryArray[indexPath.row].name
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
            destinationVC.selectedCategory = categoryArray[indexItem.row]
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
                let newItem = Category(context: self.context)
                newItem.name = enteredText
                self.categoryArray.append(newItem)
                self.saveData()
            }
            
            self.saveData()
            
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
    
    func saveData() {
        do {
            try context.save()
        } catch {
            print("error while saving category: \(error)")
        }
        tableView.reloadData()
    }
    
    // we can call this with custom request, like when searching and sorting.
    func loadData(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("error while loading categories \(error)")
            tableView.reloadData()
        }
    }
}
