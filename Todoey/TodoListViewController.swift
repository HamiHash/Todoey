import UIKit

// if we use a "tableviewcontroller", we should use tableview methods without setting the datasource and delegate (so its easier this way)
class TodoListViewController: UITableViewController {
    
    var itemArray = ["Find mike", "Buy Eggos", "Destroy Demogorgon"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - TableView DataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = itemArray[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = item
        
        return cell
    }
    
    // MARK: - TableView Delegates

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        print(itemArray[indexPath.row])

        // adding, removing the checkamrk
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }

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
            if textField.text == "" {} else {self.itemArray.append((textField.text)!)} // adding the text to out array if it is not empty
            self.tableView.reloadData() // refreshing the tableView
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { action in
            // what will happen once the user clicks the cancel button
        }
        
        alert.addAction(doneAction)
        alert.addAction(cancelAction)
    
        present (alert, animated: true, completion: nil) // presenting the alert
    }
}
