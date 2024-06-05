import Foundation
import UIKit

// Class of one floor in house

class Level:UIView{
    static var levels = [Level]()
    var numOfLevels: Int
    let elevatorPlace = UIView()
    let button = UIButton()
    var house: UIView
    static let colorsOfLevel:[UIColor] = [.white, .lightGray, .cyan, .green, .blue, .yellow, .purple]
    
    init(numOfLevels:Int, house: UIView) {
        let width = Int(house.frame.width)
        let height = Int(house.frame.height - house.safeAreaInsets.top - house.safeAreaInsets.bottom)/numOfLevels
        self.numOfLevels = numOfLevels
        self.house = house
        super.init(frame: CGRect(x: 0, y: 0+Int(house.safeAreaInsets.top), width: width, height: height))
        self.translatesAutoresizingMaskIntoConstraints = true
        
        self.backgroundColor = Level.colorsOfLevel.randomElement()
        self.center.x = house.center.x
        if !Level.levels.isEmpty{
            self.center.y = (Level.levels.last?.center.y)! + CGFloat(height)
        }
        self.layer.borderColor = .init(red: 0, green: 0, blue: 0, alpha: 0.7)
        self.layer.borderWidth = 2
        Level.levels.append(self)
        
        elevatorPlace.frame = CGRect(x: 0, y: 0, width: Int(Double(height) * 0.75), height: height)
        elevatorPlace.center.x = self.center.x
        elevatorPlace.backgroundColor = .darkGray
        self.addSubview(elevatorPlace)
        
        button.frame = CGRect(x: 0, y: 0, width: height/7, height: height/7)
        button.layer.cornerRadius = 10
        button.backgroundColor = .red
        button.layer.borderWidth = 1
        button.layer.borderColor = .init(red: 0, green: 0, blue: 0, alpha: 1)
        button.center.x = elevatorPlace.center.x + 75
        button.center.y = elevatorPlace.center.y
        self.addSubview(button)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
