import Foundation

class QuestionFactory: QuestionFactoryProtocol {

    private let questions: [QuizQuestionModel] = [
        QuizQuestionModel(image: "The Godfather",
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: true),
        QuizQuestionModel(image: "The Dark Knight",
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: true),
        QuizQuestionModel(image: "Kill Bill",
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: true),
        QuizQuestionModel(image: "The Avengers",
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: true),
        QuizQuestionModel(image: "Deadpool",
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: true),
        QuizQuestionModel(image: "The Green Knight",
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: true),
        QuizQuestionModel(image: "Old",
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: false),
        QuizQuestionModel(image: "The Ice Age Adventures of Buck Wild",
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: false),
        QuizQuestionModel(image: "Tesla",
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: false),
        QuizQuestionModel(image: "Vivarium",
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: false)
    ]
    
    weak var delegate: QuestionFactoryDelegate?
    
    init(delegate: QuestionFactoryDelegate) {
        self.delegate = delegate
    }
    
    func requestNextQuestion() {
        guard let index = (0..<questions.count).randomElement() else {
            delegate?.didReceiveNextQuestion(question: nil)
            return
        }
        
        let question = questions[safe: index]
        delegate?.didReceiveNextQuestion(question: question)
    } 
    
}
