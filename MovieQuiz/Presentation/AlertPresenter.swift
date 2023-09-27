import UIKit

class AlertPresenter {
    weak var delegate: MovieQuizViewControllerProtocol?
    
    init(delegate: MovieQuizViewControllerProtocol) {
        self.delegate = delegate
    }
    
    func show(model: AlertModel) {
        guard let delegate = delegate else { return }
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert)
        alert.view.accessibilityIdentifier = "Alert results"
        
        let action = UIAlertAction(title: model.buttonText, style: .default) { _ in
            model.completion()
        }

        alert.addAction(action)

        delegate.present(alert, animated: true, completion: nil)
    }
}
