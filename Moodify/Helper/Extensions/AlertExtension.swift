


import UIKit

extension UIViewController {
    
    func showAlert(
        title: String,
        message: String,
        style: UIAlertController.Style = .alert,
        buttonTitle: String = "OK",
        completion: (() -> Void)? = nil
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        
        let action = UIAlertAction(title: buttonTitle, style: .default) { _ in
            completion?()
        }
        
        alert.addAction(action)
        
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
    
    
    func showActionAlert(
        title: String,
        message: String,
        style: UIAlertController.Style = .alert,
        okTitle: String = "OK",
        cancelTitle: String = "Cancel",
        onOk: (() -> Void)? = nil,
        onCancel: (() -> Void)? = nil
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        
        let ok = UIAlertAction(title: okTitle, style: .default) { _ in onOk?() }
        let cancel = UIAlertAction(title: cancelTitle, style: .destructive) { _ in onCancel?() }
        
        alert.addAction(ok)
        alert.addAction(cancel)
        
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
}
