//
//  Function.swift
//  
//
//  Created by Natalia Drozd on 3.06.22.
//

import Foundation
import UIKit
import KeychainSwift

extension ViewController {
// переход при нажатии на ячейку
func tappedAtCell(key: ContentType?, indexPath: IndexPath){
    // извлекаем опционал
    guard let key = key, let values = dictionary[key] else { return }
    // если картинка
    if key == .image {
        // переходим на новый контроллер с картинкой
        let vc = ImageViewController(nibName: "ImageViewController", bundle: nil)
        //vc.loadView()
        for i in values {
            var image = UIImage()
            image = UIImage(contentsOfFile: i.path)!
            vc.imageArray.append(image)
            
        }
       // vc.image = UIImage(contentsOfFile:  values[indexPath.row].path)
        present (vc, animated: true)
    } else {
        // если папка, то открываеи этот же контроллер, так как функционал тот же
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TableVC") as? ViewController {
            // меняем адрес каталога
            vc.catalogURL = values[indexPath.row]
            vc.title = values[indexPath.row].lastPathComponent
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
// удаление ячеек
    func removeCells (arrayOfIdexes: [IndexPath]) {
    // пробегаем по массиву индексов выбранных ячеек
        arrayOfIdexes.forEach { index in
        guard let key = ContentType(rawValue: index.section), let values = dictionary[key] else { return
        }
            do {
                // удаляем наш файл из директории
                try fileManager.removeItem(at: values[index.row])
                // из массива в словаре
                dictionary[key]?.remove(at: index.row)
            } catch {
                print ("ERROR")
            }
        }
        selectionMode = .navigation
        // обновляем таблицу
        tableView.reloadData()
        myCollectionView.reloadData()
}
    
}

extension UIViewController {
    
    func showALert() {
        var checkPassword: UITextField!
        var passwordArea: UITextField!
        var userPass = UserDefaults.standard.string(forKey: "pass")
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
                UserDefaults.standard.set("\(passwordArea.text!)", forKey: "pass")
                userPass = UserDefaults.standard.string(forKey: "pass")
            }
            let cancelButton = UIAlertAction(title: "Cancel", style: .destructive)
            passwordAlert.addAction(setPasswordButton)
            passwordAlert.addAction(cancelButton)
            present(passwordAlert, animated: true)
        }
        
    }
    
}
