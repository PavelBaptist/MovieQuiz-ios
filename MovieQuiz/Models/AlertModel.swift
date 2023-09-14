import Foundation
import UIKit

final class AlertModel{
    let title: String
    let message: String
    let buttonText: String
    let completion: (() -> Void)?
    let handler: (UIAlertAction) -> Void
    
    init(title: String, message: String, buttonText: String, completion: (() -> Void)?, handler: @escaping (UIAlertAction) -> Void) {
        self.title = title
        self.message = message
        self.buttonText = buttonText
        self.completion = completion
        self.handler = handler
    }
}
