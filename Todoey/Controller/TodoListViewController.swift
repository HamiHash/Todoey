import UIKit

// if we use a "tableviewcontroller", we should use tableview methods without setting the datasource and delegate (so its easier this way)
class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    let defaults = UserDefaults.standard // initializing user default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if let items = defaults.object(forKey: "TodoListItems") as? [Item] {
            itemArray = items
        }
        
        let item1 = Item(titel: "do the math", done: false)
        itemArray.append(item1)
        
        let item2 = Item(titel: "walk dog", done: false)
        itemArray.append(item2)
        
        let item3 = Item(titel: "wash car", done: false)
        itemArray.append(item3)
        
        let item4 = Item(titel: "play rainbow six siege", done: false)
        itemArray.append(item4)
        
        let item5 = Item(titel: "do the math5", done: false)
        itemArray.append(item5)
    }
    
    //MARK: - TableView DataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = itemArray[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath) // creating cells
        
        cell.textLabel?.text = item.titel // setting the label
        
        cell.accessoryType = item.done ? .checkmark : .none // setting the items checkmark
       
        return cell
    }
    
    // MARK: - TableView Delegates
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print(itemArray[indexPath.row])
        
        // adding, removing the checkamrk
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
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
                let newItem = Item(titel: enteredText, done: false)
                self.itemArray.append(newItem)
            }
            
            self.tableView.reloadData() // refreshing the tableView
            
            self.defaults.set(self.itemArray, forKey: "TodoListItems") // setting the new array to userDefaults
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { action in
            // what will happen once the user clicks the cancel button
        }
        
        alert.addAction(doneAction)
        alert.addAction(cancelAction)
        
        present (alert, animated: true, completion: nil) // presenting the alert
    }
}
