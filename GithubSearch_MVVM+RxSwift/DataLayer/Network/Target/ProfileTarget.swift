//
//  ProfileTarget.swift
//  GithubSearch_MVVM+RxSwift
//
//  Created by 박승태 on 2023/02/26.
//

import Foundation

enum ProfileTarget {
    case requestUserInfomation
    case searchAddedStarRepository(page: Int)
    case removeStarRepository(ownerName: String, repositoryName: String)
}

extension ProfileTarget: TargetType {
    var path: String {
        switch self {
        case .requestUserInfomation:
            return API.Root.user
        case .searchAddedStarRepository:
            return API.Root.user + API.EndPoint.stars
        case .removeStarRepository(let ownerName, let repositoryName):
            return API.Root.user + API.EndPoint.stars + "\(ownerName)/\(repositoryName)"
        }
    }
    
    var queries: [String : Any] {
        switch self {
        case .requestUserInfomation, .removeStarRepository:
            return [:]
        case .searchAddedStarRepository(let page):
            return [
                "page": page,
                "per_page": 10
            ]
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .requestUserInfomation, .searchAddedStarRepository:
            return .GET
        case .removeStarRepository:
            return .DELETE
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
