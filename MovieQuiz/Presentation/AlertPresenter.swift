import Foundation
import UIKit

final class AlertPresenter {
    
    weak var delegate: AlertPresenterDelegate?
   
    init(delegate: AlertPresenterDelegate?) {
        self.delegate = delegate
    }
    
    func show(alertData: AlertModel) {
        guard let delegate else {
            return
        }
        
        let alert = UIAlertController(
            title: alertData.title,
            message: alertData.message,
            preferredStyle: .alert)
        alert.view.accessibilityIdentifier = "Alert results"
        let action = UIAlertAction(title: alertData.buttonText, style: .default, handler: alertData.handler)
        
        alert.addAction(action)
        
        delegate.present(alert, animated: true, completion: alertData.completion)
    }
    
}
