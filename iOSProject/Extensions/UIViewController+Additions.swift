//
//  UIViewController+Additions.swift
//  iOSProject
//
//  Created by SINCY on 27/01/20.
//  Copyright © 2020 SINCY. All rights reserved.
//

import UIKit

extension UIViewController {
    /// show alert corresponding error messages
    func showAlert(withTitle title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func showError(withError error: Error) {
        var message = ""
        switch error {
        case ServiceError.invalidURL:
            message = "Something is wrong with the url"
        case ServiceError.invalidResponse:
            message = "Invalid response"
        case ServiceError.errorWhileDecoding:
            message = "Something went wrong while decoding the data"
        default:
            message = error.localizedDescription
        }
        showAlert(withTitle: "Alert", message: message)
    }
}
