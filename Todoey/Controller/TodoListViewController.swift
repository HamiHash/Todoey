import UIKit

// if we use a "tableviewcontroller", we should use tableview methods without setting the datasource and delegate (so its easier this way)
class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    //    let defaults = UserDefaults.standard // initializing user default (we are not useDefault anymore here)
    
    // craeting the file to store data
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("userTodoItems")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        
        //        if let items = defaults.object(forKey: "TodoListItems") as? [Item] {
        //            itemArray = items
        //        }
        
        loadData()
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
        
        // adding, removing the checkamrk
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        self.saveData()
        
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
    
    // saves the itemArray in our "dataFilePath"
    func saveData() {
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("error while encoding")
        }
    }
    
    func loadData() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("error while decoding")
            }
        }
    }
}

