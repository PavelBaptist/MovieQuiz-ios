import Foundation

struct GameRecordModel: Codable, Comparable {
    static func < (lhs: GameRecordModel, rhs: GameRecordModel) -> Bool {
        return lhs.correct < rhs.correct
    }
    
    let correct: Int
    let total: Int
    let date: Date
}
