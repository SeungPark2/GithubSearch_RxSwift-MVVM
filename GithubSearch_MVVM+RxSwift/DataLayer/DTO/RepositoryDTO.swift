//
//  RepositoryDTO.swift
//  GithubSearch_MVVM+RxSwift
//
//  Created by 박승태 on 2023/02/09.
//

import Foundation

struct RepositoryDTO: Codable {
    let id: Int
    let node_id: String
    let name: String
    let full_name: String
    let owner: OwnerDTO
    let description: String
    let html_url: String
    let updated_at: Date
    let size: Int
    let stargazers_count: Int
    let language: String
    let license: LicenseDTO
    let topics: [String]
    let visibility: String
    
    enum CodingKeys: String, CodingKey {
        case id, node_id, name, full_name, owner, description, html_url, updated_at, size, stargazers_count,
             language, license, topics, visibility
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = (try? container.decode(Int.self, forKey: .id)) ?? 0
        node_id = (try? container.decode(String.self, forKey: .node_id)) ?? ""
        name = (try? container.decode(String.self, forKey: .name)) ?? ""
        full_name = (try? container.decode(String.self, forKey: .full_name)) ?? ""
        owner = (try? container.decode(OwnerDTO.self, forKey: .owner)) ?? OwnerDTO()
        description = (try? container.decode(String.self, forKey: .description)) ?? ""
        html_url = (try? container.decode(String.self, forKey: .html_url)) ?? ""
        updated_at = (try? container.decode(Date.self, forKey: .updated_at)) ?? Date()
        size = (try? container.decode(Int.self, forKey: .size)) ?? 0
        stargazers_count = (try? container.decode(Int.self, forKey: .stargazers_count)) ?? 0
        language = (try? container.decode(String.self, forKey: .language)) ?? ""
        license = (try? container.decode(LicenseDTO.self, forKey: .license)) ?? LicenseDTO()
        topics = (try? container.decode([String].self, forKey: .topics)) ?? []
        visibility = (try? container.decode(String.self, forKey: .visibility)) ?? ""
    }
}

extension RepositoryDTO {
    
    func toDomain() -> Repository {
        Repository(
            id: id,
            name: name,
            nameWithOwnerName: full_name,
            owner: owner.toDomain(),
            description: description,
            htmlURL: html_url,
            updatedTime: updated_at,
            size: size,
            starCount: stargazers_count,
            language: language,
            license: license.toDomain(),
            topics: topics,
            visibility: visibility
        )
    }
}
