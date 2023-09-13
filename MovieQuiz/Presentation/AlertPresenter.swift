import Foundation
import UIKit

final class AlertPresenter {
    
    weak var delegate: AlertPresenterDelegate?
    let alertHandler: (UIAlertAction) -> Void
    init(delegate: AlertPresenterDelegate? = nil, alertHandler: @escaping (UIAlertAction) -> Void) {
        self.delegate = delegate
        self.alertHandler = alertHandler
    }
    
    func show(alertData: AlertModel) {
        guard let delegate else {
            return
        }
        
        let alert = UIAlertController(
            title: alertData.title,
            message: alertData.message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: alertData.buttonText, style: .default, handler: alertHandler)
        
        alert.addAction(action)
        
        delegate.present(alert, animated: true, completion: alertData.completion)
    }
    
}
