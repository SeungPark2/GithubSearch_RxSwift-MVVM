//
//  Foundation.swift
//  GithubSearch_MVVM+RxSwift
//
//  Created by 박승태 on 2023/02/10.
//

import Foundation

enum GithubSearchRepositoryTarget {
    case searchRepository(keyword: String, page: Int)
}

extension GithubSearchRepositoryTarget: TargetType {
    var path: String {
        switch self {
        case .searchRepository:
            return API.Root.search + API.EndPoint.repositories
        }
    }
    
    var queries: [String : Any] {
        switch self {
        case .searchRepository(let keyword, let page):
            return [
                "q": keyword,
                "page": page,
                "per_page": 10
            ]
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .searchRepository:
            return .GET
        }
    }
    
    var headers: [String : String] {
        var headers: [String: String] = [:]
        headers["Accept-Type"] = "application/vnd.github+json"
        headers["X-GitHub-Api-Version"] = "2022-11-28"

//        headers["Authorization"] = "Bearer \(apiToken)"
        
        return headers
    }
}
