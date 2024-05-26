//
//  UIViewController+Extension.swift
//  Shoplive_iOS_ParkJiHo
//
//  Created by jiho park on 5/25/24.
//

import UIKit

import  Moya

extension UIViewController {
    func presentAlert(message: String? = nil,
                      confirmTitle: String? = nil,
                      confirmHandler: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        
        if let confirmTitle = confirmTitle {
            let confirmAction = UIAlertAction(title: confirmTitle, style: .default) { _ in
                confirmHandler?()
            }
            alertController.addAction(confirmAction)
        }
        present(alertController, animated: true)
    }
}

extension UIViewController {
    func handleError(_ error: Error) {
        if let error = error as? NetworkError {
            self.presentAlert(message: error.localizedDescription, confirmTitle: "확인")
        } else if let error = error as? MoyaError {
            guard let afError = error.asAFError, !afError.isExplicitlyCancelledError else { return }
            self.presentAlert(message: error.localizedDescription, confirmTitle: "확인")
        } else if let error = error as? DatabaseError {
            self.presentAlert(message: error.localizedDescription, confirmTitle: "확인")
        }
    }
}

