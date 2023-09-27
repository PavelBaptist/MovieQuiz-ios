import UIKit

protocol MovieQuizViewControllerProtocol: AnyObject, UIViewController {
    func show(quiz step: QuizStepViewModel)
    
    func highlightImageBorder(isCorrectAnswer: Bool)
    
    func showLoadingIndicator()
    func hideLoadingIndicator()
    
    func isEnabledButtons(enabled: Bool)
}
