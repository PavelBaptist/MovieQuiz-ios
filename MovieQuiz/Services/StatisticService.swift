import Foundation

protocol StatisticService{
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecordModel { get }
    
    func store(correct count: Int, total amount: Int)
}

final class StatisticServiceImplementation: StatisticService{
    
    private let userDefaults = UserDefaults.standard
    
    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
    
    var totalAccuracy: Double{
        get {
            let data = userDefaults.double(forKey: Keys.total.rawValue)
            return data
        }
        set {
            userDefaults.set(newValue, forKey: Keys.total.rawValue)
        }
    }
    
    var gamesCount: Int {
        get {
            let data = userDefaults.integer(forKey: Keys.gamesCount.rawValue)
            return data
        }
        set {
            userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
        
    }
    
    var bestGame: GameRecordModel {
        get {
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
                let record = try? JSONDecoder().decode(GameRecordModel.self, from: data) else {
                return GameRecordModel(correct: 0, total: 0, date: Date())
            }
            
            return record
        }
        
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
            
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
    
    func store(correct count: Int, total amount: Int) {
        
        // best game
        let newGame = GameRecordModel(correct: count, total: amount, date: Date())
        if (newGame > bestGame) {
            bestGame = newGame
        }
        
        // games count
        gamesCount = gamesCount + 1
        
        // total
        let accuracy: Double = (Double(amount) / 100 * Double(count)) * 100
        if (totalAccuracy == 0){
            totalAccuracy = accuracy
        } else {
            totalAccuracy = (totalAccuracy + accuracy) / 2
        }
    }
    
}


