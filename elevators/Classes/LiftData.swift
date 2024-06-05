import Foundation

// This structure is maked for download JSON file
struct LiftData:Decodable{
    
    var timeToElevate: Int?
    var timeOpenCloseDoor: Int?
    var houseLevels: Int?
    var lifts: [Lift]?
    
}
