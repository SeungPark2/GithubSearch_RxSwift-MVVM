//
//  User.swift
//  GithubSearch_MVVM+RxSwift
//
//  Created by 박승태 on 2023/02/08.
//

import Foundation

struct User {
    let id: Int
    let name: String
    let email: String
    let profileImageURL: String?
    let company: String?
    let blog: String?
    let location: String?
    let twitterUsername: String?
    let followerCount: Int
    let followingCount: Int
    
    static func initailization() -> User {
        User(id: 0, name: "", email: "", profileImageURL: nil, company: nil, blog: nil, location: nil, twitterUsername: nil, followerCount: 0, followingCount: 0)
    }
}
