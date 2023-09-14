import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestionModel?)
    func didLoadDataFromServer()
    func didFailToLoadData(with error: Error)
}
