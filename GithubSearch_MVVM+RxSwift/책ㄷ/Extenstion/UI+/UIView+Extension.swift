//
//  UIView+Extension.swift
//  GithubSearch_MVVM+RxSwift
//
//  Created by 박승태 on 2023/02/08.
//

import UIKit

extension UIView {
    
    func addSubViews(_ views: UIView...) {
        _ = views.map { addSubview($0) }
    }
    
    func round(radius: CGFloat? = nil) {
        layer.masksToBounds = true

        guard let radius = radius else {
            layer.cornerRadius = bounds.height / 2
            return
        }
        
        layer.cornerRadius = radius
    }
}
