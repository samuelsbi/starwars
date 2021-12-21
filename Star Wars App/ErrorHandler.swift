import UIKit

protocol ErrorHandler: AnyObject {
    func handle(error: Error)
}

extension ErrorHandler where Self: UIViewController {
    func handle(error: Error) {
        DispatchQueue.main.async { [weak self] in
            let alert = UIAlertController(title: "Error",
                                          message: error.localizedDescription,
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default) { _ in
                alert.dismiss(animated: true)
            })
            self?.present(alert, animated: true)
        }
    }
}
