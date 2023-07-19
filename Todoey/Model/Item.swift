
import Foundation

class Item: Codable {
    let titel: String
    var done: Bool = false
    
    init(titel: String, done: Bool) {
        self.titel = titel
        self.done = done
    }
}
