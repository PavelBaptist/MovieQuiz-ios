import Foundation

protocol QuestionFactoryProtocol {
    func loadData()
    func requestNextQuestion()
    func dataIsLoaded() -> Bool
}
