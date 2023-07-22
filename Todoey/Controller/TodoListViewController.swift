import UIKit
import CoreData

// if we use a "tableviewcontroller", we should use tableview methods without setting the datasource and delegate (so its easier this way)
class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    var selectedCategory: Category? {
        didSet {
            navigationItem.title = selectedCategory?.name
            loadData()
        }
    }
    // we get the context in the "AppDelegate" like this:
    // more about this line at "018 How to Save Data with Core Data" 2:35
    // code in the () is basically AppDelegate in an Object form "not class", and we can accessed 'context' from it
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    //MARK: - TableView DataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) // creating cells
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title // setting the label
        cell.accessoryType = item.done ? .checkmark : .none // setting the items checkmark
        
        return cell
    }
    
    // MARK: - TableView Delegates
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // adding, removing the checkamrk
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
//        // deleting an item from core data
//        context.delete(itemArray[indexPath.row]) // 1st: delete it in core data
//        itemArray.remove(at: indexPath.row) // 2nd: delete it from local itemArray (must do this after first step)
//        saveData() // 3rd: save the adjusted entity to coreData
        
        saveData()
        
        // reloading to update the UI
        tableView.reloadData()
        
        
        // This will make the clicked item "flash". (or deselect)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add New Item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        // Creating the alert
        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
        
        // Adding the textfield to alert
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Todo"
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
                let newItem = Item(context: self.context)
                newItem.title = enteredText
                newItem.done = false
                newItem.parentCategory = self.selectedCategory
                self.itemArray.append(newItem)
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
        
        present (alert, animated: true, completion: nil) // presenting the alert
    }
    
    func saveData() {
        do {
            try context.save()
        } catch {
            print("error while encoding: \(error)")
        }
    }
    
    // we can call this with custom request, like when searching and sorting.
    func loadData(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        if predicate == nil {
            request.predicate = categoryPredicate
        } else {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate!])        }
         do {
             itemArray = try context.fetch(request)
        } catch {
            print("error while decoding \(error)")
        }
    }
}

//MARK: - UISearchBarDelegate

extension TodoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // we should edit the request so we should declare it:
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        // this means that it contans whats in the entered text
        let searchPredicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        // the will order it
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        // we load the data with our custom request
        loadData(with: request, predicate: searchPredicate)
        // reload the UI
        tableView.reloadData()
    }
    
    // when user removes the search bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadData()
            tableView.reloadData()
            
            // Lowering the keyboard
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
