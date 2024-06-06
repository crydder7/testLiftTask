import Foundation
import UIKit

// View of lift, that we downloaded from JSON, we can use it for animation

class LiftView: UIView{
    
    let modelOfLift : Lift?
    let numOfLevels : Int
    let mine: UIView
    var width = 0
    var height = 0
    let view : UIView
    public var queue = [Int]()
    public var currentLevel = 0
    
    init(modelOfLift: Lift?, numOfLevels: Int, view:UIView, mineOfFirstFloor: UIView) {
        self.modelOfLift = modelOfLift
        self.view = view
        self.mine = mineOfFirstFloor
        self.numOfLevels = numOfLevels
        self.height = Int(self.mine.bounds.height)
        self.width = Int(self.mine.bounds.height * 0.75)
        super.init(frame: CGRect(x: 0, y: 0, width: width, height: height))
        self.translatesAutoresizingMaskIntoConstraints = false
        self.center = mineOfFirstFloor.center
        self.backgroundColor = .black
        self.layer.borderColor = .init(red: 200, green: 200, blue: 200, alpha: 0.75)
        self.layer.borderWidth = 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
