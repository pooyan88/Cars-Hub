//
//  UIViewControllerExtension.swift
//  Cars Hub
//
//  Created by Pooyan J on 7/5/1402 AP.
//

import UIKit

extension UIViewController {
    
    enum StoryboardName: String {
        case main = "Main"
    }
    
    
    static func instantiate<T: UIViewController>(appStoryboard: StoryboardName) -> T {
        let storyboard = UIStoryboard(name: appStoryboard.rawValue, bundle: nil)
        let identifier = String(describing: self)
        return storyboard.instantiateViewController(withIdentifier: identifier) as! T
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func showNetworkError(error: NetworkRequests.MyError) {
        switch error {
        case .decodeError:
            AlertManager.shared.showAlert(alertTitle: "Error", alertDescription: "Decode Error", alertConfirmationButtonTitle: "OK", view: self)
        case .serverError:
            AlertManager.shared.showAlert(alertTitle: "Error", alertDescription: "Server Error", alertConfirmationButtonTitle: "OK", view: self)
        case .urlError:
            AlertManager.shared.showAlert(alertTitle: "Error", alertDescription: "Try Again", alertConfirmationButtonTitle: "OK", view: self)
        }
    }
}
