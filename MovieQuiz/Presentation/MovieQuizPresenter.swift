import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    // MARK: - Privates properties
    private let statisticService: StatisticService!
    private let alertPresenter: AlertPresenter!
    private let questionsAmount: Int = 10

    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestionIndex: Int = 0
    private var correctAnswers: Int = 0
    private var currentQuestion: QuizQuestion?

    private weak var viewController: MovieQuizViewControllerProtocol?
    
    // MARK: - Init
    init(viewController: MovieQuizViewControllerProtocol) {
        self.viewController = viewController

        statisticService = StatisticServiceImplementation()
        alertPresenter = AlertPresenter(delegate: viewController)
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
        viewController.showLoadingIndicator()
    }

    // MARK: Public methods
    func yesButtonClicked() {
        didAnswer(isYes: true)
    }

    func noButtonClicked() {
        didAnswer(isYes: false)
    }
    
    // MARK: - Privates methods
    private func didAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else {
            return
        }

        let givenAnswer = isYes

        proceedWithAnswer(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }

    private func proceedWithAnswer(isCorrect: Bool) {
        didAnswer(isCorrectAnswer: isCorrect)

        viewController?.highlightImageBorder(isCorrectAnswer: isCorrect)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.proceedToNextQuestionOrResults()
        }
    }

    private func proceedToNextQuestionOrResults() {
        if isLastQuestion() {
            let text = correctAnswers == questionsAmount ?
            "Поздравляем, вы ответили на 10 из 10!" :
            "Вы ответили на \(correctAnswers) из 10, попробуйте ещё раз!"

            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть ещё раз")
                showResultAlert(quiz: viewModel)
        } else {
            switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
    
    private func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }

    private func didAnswer(isCorrectAnswer: Bool) {
        if isCorrectAnswer {
            correctAnswers += 1
        }
    }

    private func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.requestNextQuestion()
    }

    private func switchToNextQuestion() {
        currentQuestionIndex += 1
    }

    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
    }

    private func showResultAlert(quiz result: QuizResultsViewModel) {
        guard let viewController = viewController else { return }
        viewController.hideLoadingIndicator()
        
        let message = makeResultsMessage()
        
        let alert = AlertModel(
            title: result.title, message: message, buttonText: result.buttonText) { [weak self] in
                guard let self = self else { return }
                
                self.restartGame()
            }
        alertPresenter.show(model: alert)
    }
    
    private func showNetworkErrorAlert(message: String) {
        guard let viewController = viewController else { return }
        viewController.hideLoadingIndicator()
 
        let alert = AlertModel(
            title: "Ошибка", message: message, buttonText: "Попробовать ещё раз") { [weak self] in
                guard let self = self else { return }
                
                self.restartGame()
            }
        alertPresenter.show(model: alert)
        
    }
    
    private func makeResultsMessage() -> String {
        statisticService.store(correct: correctAnswers, total: questionsAmount)

        let bestGame = statisticService.bestGame

        let totalPlaysCountLine = "Количество сыгранных квизов: \(statisticService.gamesCount)"
        let currentGameResultLine = "Ваш результат: \(correctAnswers)\\\(questionsAmount)"
        let bestGameInfoLine = "Рекорд: \(bestGame.correct)\\\(bestGame.total) (\(bestGame.date.dateTimeString))"
        let averageAccuracyLine = "Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%"

        let resultMessage = [
        currentGameResultLine, totalPlaysCountLine, bestGameInfoLine, averageAccuracyLine
        ].joined(separator: "\n")

        return resultMessage
    }
        
    // MARK: - QuestionFactoryDelegate
    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }

    func didFailToLoadData(with error: Error) {
        let message = error.localizedDescription
        showNetworkErrorAlert(message: message)
    }

    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }

        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async{ [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }
}
