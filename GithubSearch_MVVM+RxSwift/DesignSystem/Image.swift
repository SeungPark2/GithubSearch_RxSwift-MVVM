//
//  Image.swift
//  GithubSearch_MVVM+RxSwift
//
//  Created by 박승태 on 2023/02/08.
//

import UIKit

struct Image {
    struct Logo {
        static let white = UIImage(named: "logoWhite")
    }
    
    struct LoginLogout {
        static let login = UIImage(named: "login")
        static let logout = UIImage(named: "logout")
    }
    
    struct Star {
        static let empty = UIImage(systemName: "star")
        static let fill = UIImage(systemName: "star.fill")
    }
    
    struct Book {
        static let closeFill = UIImage(systemName: "book.closed.fill")
    }
}
