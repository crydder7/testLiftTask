import Foundation
import UIKit

class LiftView: UIView{
    
    let modelOfLift: Lift?
    let numOfLevels : Int
    let mine: UIView
    let view : UIView
    public var currentLevel = 0
    
    init(modelOfLift: Lift?, numOfLevels: Int, view:UIView, mineOfFirstFloor: UIView) {
        self.modelOfLift = modelOfLift
        self.view = view
        self.mine = mineOfFirstFloor
        self.numOfLevels = numOfLevels
        let height = Int(self.view.frame.height)/numOfLevels
        super.init(frame: CGRect(x: 0, y: 0, width: Int(Double(height) * 0.75), height: height))
        self.center = mineOfFirstFloor.center
        self.backgroundColor = .black
        self.layer.borderColor = .init(red: 200, green: 200, blue: 200, alpha: 0.75)
        self.layer.borderWidth = 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
