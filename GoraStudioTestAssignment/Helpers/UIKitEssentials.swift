//
//  UIViewController + ShowAlert.swift
//  GoraStudioTestAssignment
//
//  Created by Vladimir Banushkin on 19.01.2022.
//

import UIKit

import UIKit

// MARK: - Error displaying
extension UIViewController {
    func alert(error: ErrorDomain) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(
                title: error.description.title,
                message: error.description.error,
                preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .default))
            self.present(alertController, animated: true, completion: nil)
        }
    }
}

// -- Fast autoLayout ready making
extension UIView {
    func toAutoLayout() {
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}

// --Locking view for whole window.
final class LockingView {
    static var window: UIWindow? = UIApplication.shared.windows.first(where: { $0.isKeyWindow })
    static let activityIndicator = UIActivityIndicatorView(frame: window?.bounds ?? UIScreen.main.bounds)

    static func lock() {
        prepareIndicator()
        DispatchQueue.main.async {
            activityIndicator.startAnimating()
        }
    }


    static func unlock() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
        }
    }

    static private func prepareIndicator() {
        DispatchQueue.main.async {
            activityIndicator.backgroundColor = .white.withAlphaComponent(0.7)
            activityIndicator.color = .darkGray
            activityIndicator.style = .large
            window?.addSubview(activityIndicator)
        }
    }
}
