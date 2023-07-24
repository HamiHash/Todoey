
import Foundation
import UIKit

class EditViewController: UITableViewController  {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 55
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            // 1. delete it from database
            self.updateModal(at: indexPath)
            // 2. delete the cell
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
    
    func updateModal(at indexPath: IndexPath) {
        // we override this function in other tableViewa
    }
}
