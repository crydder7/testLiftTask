import UIKit

class ViewController: UIViewController {
    //MARK: URL
    let urlString = "https://demo2794821.mockable.io/"
    
    //MARK: Lifts arrays
    var liftsArray = [Lift]() // Data from JSON(Model of lifts)
    var liftViews = [LiftView]() // All lifts as Views
    var freeLifts = [LiftView]() // Lift, there are free in the moment as Views
    
    var floors = [Level]() // All of floors in house
    var waitingLevels = [Int]() // Numver of floors, there are already waiting lif(there not available to call more lifts)
    var numOfLevels = Int()
    var timeOpenClose = 0
    
    override func viewDidLoad() {
        self.view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        super.viewDidLoad()
        
        fetchElevatorData(from: urlString) { data in
            let liftsInfo = LiftData.init(timeToElevate: data!.timeToElevate, timeOpenCloseDoor: data!.timeOpenCloseDoor, houseLevels: data!.houseLevels, lifts: data!.lifts)
            let num = liftsInfo.houseLevels
            let fl = liftsInfo.lifts
            let time = liftsInfo.timeOpenCloseDoor
            
            DispatchQueue.main.async {
                self.numOfLevels = num ?? 6
                self.timeOpenClose = time ?? 3
                if let floors = fl{
                    self.liftsArray = floors
                }
                self.createFloors()
                self.createLift()
            }
        }
    }
    
    
    //MARK: JSON parsing
    func fetchElevatorData(from urlString: String, completion: @escaping (LiftData?) -> Void) {
        
        guard let url = URL(string: urlString) else {
            print("Некорректный URL")
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Ошибка сетевого запроса: \(error)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("Не удалось получить данные")
                completion(nil)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let elevatorData = try decoder.decode(LiftData.self, from: data)
                completion(elevatorData)
            } catch {
                print("Ошибка декодирования JSON: \(error)")
                completion(nil)
            }
        }
        
        task.resume()
    }
    
    
    //MARK: Creating objects
    func createFloors(){
        
        for _ in 0..<numOfLevels{
            self.floors.append(Level(numOfLevels: numOfLevels, house: self.view))
        }
        
        for i in floors{
            i.button.addTarget(self, action: #selector(callLift(sender:)), for: .touchUpInside)
            view.addSubview(i)
        }
        floors.reverse()
        
    }
    
    func createLift(){
        guard !floors.isEmpty else { return }
        
        for i in self.liftsArray{
            self.liftViews.append(LiftView(modelOfLift: i, numOfLevels: numOfLevels, view: self.view, mineOfFirstFloor: floors.first!))
        }
        
        for i in liftViews{
            freeLifts.append(i)
            view.addSubview(i)
        }
    }
    
    //MARK: Action for button
    @objc func callLift(sender:UIButton){
        guard !liftViews.isEmpty else { return }
        var numOfFloor = 0
        for i in 0..<floors.count{
            if sender == floors[i].button{
                numOfFloor = i
            }
        }
        
        if !self.waitingLevels.contains(numOfFloor){
            self.waitingLevels.append(numOfFloor)
            sender.backgroundColor = .green
        } else { return }
        
        var lift = liftViews.randomElement()!
        var min = Int.max
        for i in liftViews{
           var levelOfLift = 0
           if i.queue.isEmpty{
               levelOfLift = i.currentLevel
           } else{
               levelOfLift += i.queue.last!
               
           }
           if abs(levelOfLift - numOfFloor) < min{
               lift = i
               min = abs(levelOfLift - numOfFloor)
           }
       }
       if !freeLifts.isEmpty{
           for i in freeLifts{
               let levelOfLift = i.currentLevel
               if abs(levelOfLift - numOfFloor) <= min{
                   lift = i
                   min = abs(levelOfLift - numOfFloor)
               }
           }
       }
        
        if lift.queue.isEmpty{
            guard let indexOfLift = self.freeLifts.firstIndex(of: lift) else { return }
            self.freeLifts.remove(at: indexOfLift)
            lift.queue.append(numOfFloor)
            moveLift(lift: lift)
        } else {
            lift.queue.append(numOfFloor)
        }
        
    }
    
    
    //MARK: Lift moving function
    func moveLift(lift:LiftView){
        guard let numOfFloor = lift.queue.first else { return }
        let duration = abs((lift.currentLevel - numOfFloor)) * 4
        UIView.animate(withDuration: TimeInterval(duration)) {
            lift.center.y = self.floors[numOfFloor].center.y
        } completion: { final in
            lift.openDoors(duration: TimeInterval(self.timeOpenClose))
            lift.currentLevel = numOfFloor
            guard let indexOfFloor = self.waitingLevels.firstIndex(of: numOfFloor) else { return }
            self.waitingLevels.remove(at: indexOfFloor)
            self.floors[numOfFloor].button.backgroundColor = .red
            lift.queue.removeFirst()
            if lift.queue.isEmpty{
                self.freeLifts.append(lift)
            } else{
                self.moveLift(lift: lift)
            }
        }
    }
    
}

