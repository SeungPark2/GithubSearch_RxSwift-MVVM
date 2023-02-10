//
//  APIPrefix.swift
//  GithubSearch_MVVM+RxSwift
//
//  Created by 박승태 on 2023/02/11.
//

import Foundation

struct API {
    struct Server {
        static let base: String             = "https://api.github.com"
        static let gitHub: String           = "https://github.com"
    }

    struct Root {
        static let search: String           = "/search"
        static let login: String            = "/login"
        static let oauth: String            = "/oauth"
        static let user: String             = "/user"
    }

    struct EndPoint {
        static let repositories: String     = "/repositories"
        static let authroize: String        = "/authorize"
        static let stars: String            = "/starred"
    }

}
