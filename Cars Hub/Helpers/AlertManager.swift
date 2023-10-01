//
//  AlertManager.swift
//  Cars Hub
//
//  Created by Pooyan J on 7/5/1402 AP.
//

import UIKit

class AlertManager {
    
    static let shared = AlertManager()
    
    func showAlert(alertTitle: String, alertDescription: String, alertConfirmationButtonTitle: String, view: UIViewController) {
        let alert = UIAlertController(title: alertTitle, message: alertDescription, preferredStyle: .alert)
        let action = UIAlertAction(title: alertConfirmationButtonTitle, style: .default)
        alert.addAction(action)
        view.present(alert, animated: true)
    }
}
