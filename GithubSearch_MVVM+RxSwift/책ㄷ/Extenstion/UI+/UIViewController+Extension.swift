//
//  UIViewController+Extension.swift
//  GithubSearch_MVVM+RxSwift
//
//  Created by 박승태 on 2023/02/15.
//

import UIKit

extension UIViewController {
    
    func showAlertPopup(message: String?, buttons: [UIAlertAction]) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)

        for button in buttons {
            alertController.addAction(button)
        }
        
        present(alertController, animated: true)
    }
}
