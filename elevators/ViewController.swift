import UIKit

class ViewController: UIViewController {
    //MARK: URL
    let urlString = "https://demo2794821.mockable.io/"
    
    //MARK: Lifts arrays
    var liftsArray = [Lift]() // Data from JSON(Model of lifts)
    var liftViews = [LiftView]() // All lifts as Views
    var freeLifts = [LiftView]() // Lift, there are free in the moment as Views
    
    
    var floors = [Level]()
    var waitingLevels = [Int]() // Numver of floors, there are already waiting lif(there not available to call more lifts)
    var numOfLevels = 5
    
    override func viewDidLoad() {
        self.view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        super.viewDidLoad()
        
        fetchElevatorData(from: urlString) { data in
            let liftsInfo = LiftData.init(timeToElevate: data!.timeToElevate, timeOpenCloseDoor: data!.timeOpenCloseDoor, houseLevels: data!.houseLevels, lifts: data!.lifts)
            let num = liftsInfo.houseLevels
            let fl = liftsInfo.lifts
            
            DispatchQueue.main.async {
                self.numOfLevels = num ?? 6
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
        
        guard !freeLifts.isEmpty else { return }
        
        var numOfFloor = 0
        for i in 0..<floors.count{
            if sender == floors[i].button{
                numOfFloor = i
            }
        }
        
        guard !waitingLevels.contains(numOfFloor) else { return }
        waitingLevels.append(numOfFloor)
        
        var lift = freeLifts.randomElement()!
        var min = Int.max
        for i in freeLifts{
            if abs(i.currentLevel - numOfFloor) < min{
                min = abs(i.currentLevel - numOfFloor)
                lift = i
            }
        }
        
        let duration = abs((lift.currentLevel - numOfFloor)) * 4
        
        UIView.animate(withDuration: TimeInterval(duration)) {
            lift.center.y = self.floors[numOfFloor].center.y
            guard let indexOfLift = self.freeLifts.firstIndex(of: lift) else { return }
            self.freeLifts.remove(at: indexOfLift)
        } completion: { final in
            lift.currentLevel = numOfFloor
            guard let indexOfFloor = self.waitingLevels.firstIndex(of: numOfFloor) else { return }
            self.freeLifts.append(lift)
            self.waitingLevels.remove(at: indexOfFloor)
        }

    }
}

