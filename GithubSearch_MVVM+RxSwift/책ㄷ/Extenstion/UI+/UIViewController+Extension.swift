//
//  UIViewController+Extension.swift
//  GithubSearch_MVVM+RxSwift
//
//  Created by 박승태 on 2023/02/15.
//

import UIKit

import SnapKit

extension UIViewController {
    
    func showAlertPopup(message: String?, buttons: [UIAlertAction]) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)

        for button in buttons {
            alertController.addAction(button)
        }
        
        present(alertController, animated: true)
    }
    
    func showToastLabel(message : String?) {
        if let toastLabel = view.viewWithTag(55) as? UILabel {
            toastLabel.text = message
            return
        }
        
        let toastLabel = UILabel()
        toastLabel.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.7)
        toastLabel.textColor = .white
        toastLabel.textAlignment = .center
        toastLabel.font = UIFont.boldSystemFont(ofSize: 16)
        toastLabel.text = message
        toastLabel.numberOfLines = 0
        toastLabel.tag = 55
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds  =  true
        toastLabel.alpha = 0
        
        view.addSubview(toastLabel)
        
        toastLabel.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(105)
        }
        
        view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.3,delay: 0, options: .allowAnimatedContent, animations: {
            toastLabel.alpha = 1
        },
        completion: {_ in })
    }
    
    func hideToastLabel() {
        UIView.animate(withDuration: 0.3, delay: 2, options: .curveEaseIn, animations: {
            self.view.viewWithTag(55)?.alpha = 0
            self.view.viewWithTag(55)?.removeFromSuperview()
        })
    }
}
