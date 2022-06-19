//
//  UiViewController + extension.swift
//  hw17NatalliaDrozd
//
//  Created by Natalia Drozd on 15.06.22.
//

import Foundation
import KeychainSwift
import UIKit

extension UIViewController {
    
    func isAppAlreadyLaunchedOnce() -> Bool {
        let defaults = UserDefaults.standard
        if let _ = defaults.string(forKey: "isAppAlreadyLaunchedOnce") {
            return true
        } else {
            defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
            return false
        }
    }
    
    func showALert() {
        let keychain = KeychainSwift()
        if !isAppAlreadyLaunchedOnce() {
            keychain.clear()
        }
        var checkPassword: UITextField!
        var passwordArea: UITextField!
        var userPass = keychain.get("pass")
        if userPass != nil {
            let checkPasswordAlert = UIAlertController(title: "Enter password", message: nil, preferredStyle: .alert)
            checkPasswordAlert.addTextField { textField in
                textField.placeholder = "Enter password"
                textField.isSecureTextEntry = true
                checkPassword = textField
            }
            let checkButton = UIAlertAction(title: "Check", style: .cancel) { _ in
                
                if checkPassword.text  != userPass {
                    let errorAlert = UIAlertController(title: "Wrong password", message: nil, preferredStyle: .alert)
                    let tryButton = UIAlertAction(title: "try again", style: .cancel) { _ in
                        self.present(checkPasswordAlert, animated: true)
                    }
                    errorAlert.addAction(tryButton)
                    self.present(errorAlert, animated: true)
                }
            }
            checkPasswordAlert.addAction(checkButton)
            present(checkPasswordAlert, animated: true)
        } else {
            let passwordAlert = UIAlertController(title: "Do you want set password?", message: nil, preferredStyle: .alert)
            passwordAlert.addTextField { textField in
                textField.placeholder = "Enter password"
                textField.isSecureTextEntry = true
                passwordArea = textField
            }
            let setPasswordButton = UIAlertAction(title: "Set Password", style: .cancel) {_ in
                guard passwordArea.text != nil, let password = passwordArea.text else {
                    return
                }
                keychain.set(password, forKey: "pass")
                userPass = keychain.get("pass")
            }
            let cancelButton = UIAlertAction(title: "Cancel", style: .destructive)
            passwordAlert.addAction(setPasswordButton)
            passwordAlert.addAction(cancelButton)
            present(passwordAlert, animated: true)
        }
        
    }
    
}

