//
//  RepositorySearchResultDTO.swift
//  GithubSearch_MVVM+RxSwift
//
//  Created by 박승태 on 2023/02/09.
//

import Foundation

struct RepositorySearchResultDTO: Codable {
    let total_count: Int
    let incomplete_results: Bool
    let repositories: [RepositoryDTO]
    
    enum CodingKeys: String, CodingKey {
        case total_count, incomplete_results
        case repositories = "items"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        total_count = (try? container.decode(Int.self, forKey: .total_count)) ?? 0
        incomplete_results = (try? container.decode(Bool.self, forKey: .incomplete_results)) ?? false
        repositories = (try? container.decode([RepositoryDTO].self, forKey: .repositories)) ?? []
    }
}
