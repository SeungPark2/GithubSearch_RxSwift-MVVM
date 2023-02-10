//
//  Repository.swift
//  GithubSearch_MVVM+RxSwift
//
//  Created by 박승태 on 2023/02/10.
//

import Foundation

struct Repository: Hashable {
    let id: Int
    let name: String
    let nameWithOwnerName: String
    let owner: Owner
    let description: String
    let htmlURL: String
    let updatedTime: Date
    let size: Int
    let starCount: Int
    let language: String
    let license: License
    let topics: [String]
    let visibility: String
    
    static func == (lhs: Repository, rhs: Repository) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
