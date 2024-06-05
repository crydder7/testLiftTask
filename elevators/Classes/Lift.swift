import Foundation

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
