import UIKit
import RealmSwift

// if we use a "tableviewcontroller", we should use tableview methods without setting the datasource and delegate (so its easier this way)
class TodoListViewController: EditViewController {
    
    var todoItems: Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory: Category? {
        didSet {
            navigationItem.title = selectedCategory?.name
            loadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - TableView DataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) // creating cells
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title // setting the label
            cell.accessoryType = item.done ? .checkmark : .none // setting the items checkmark
        } else {
            cell.textLabel?.text = "No items added"
        }
        
        return cell
    }
    
    // MARK: - TableView Delegates
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // checking - unchecking with Realm
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("error while toggling check and saving it to realm \(error)")
            }
        }
        
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
                if let currentCategory = self.selectedCategory {
                    do {
                        try self.realm.write {
                            let newItem = Item()
                            newItem.title = textField.text!
                            newItem.date = Date()
                            currentCategory.items.append(newItem) // Relationship List
                        }
                    } catch {
                        print("error while saving to realm \(error)")
                    }
                }
                self.tableView.reloadData()
            }
            
            self.tableView.reloadData() // refreshing the tableView
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { action in
            // what will happen once the user clicks the cancel button
        }
        
        alert.addAction(doneAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil) // presenting the alert
    }
    
    func loadData() {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "date", ascending: true)
        tableView.reloadData()
    }
    
    override func updateModal(at indexPath: IndexPath) {
        do {
            try realm.write {
                realm.delete(todoItems![indexPath.row])
            }
        } catch {
            print("error deleting the row: \(error)")
        }
    }
}

//MARK: - UISearchBarDelegate

extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "date", ascending: true)
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
