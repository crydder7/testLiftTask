import Foundation

struct LiftData:Decodable{
    
    var timeToElevate: Int?
    var timeOpenCloseDoor: Int?
    var houseLevels: Int?
    var lifts: [Lift]?
    
}
