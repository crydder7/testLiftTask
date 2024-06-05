import Foundation

// Class for download lift information from JSON (It's a model of lift)
class Lift : Decodable{
    
    let id : Int?
    let company : String?
    let maxWeight : Int?
    
    init(id: Int, company: String, maxWeight: Int) {
        self.id = id
        self.company = company
        self.maxWeight = maxWeight
    }
}
