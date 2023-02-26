//
//  UserInfomationDTO.swift
//  GithubSearch_MVVM+RxSwift
//
//  Created by 박승태 on 2023/02/26.
//

import Foundation

struct UserInfomationDTO: Codable {
    let id: Int
    let name: String
    let avatar_url: String?
    let company: String?
    let blog: String?
    let location: String?
    let email: String
    let twitter_username: String?
    let followers: Int
    let following: Int
    
    enum CodingKeys: String, CodingKey {
        case id, avatar_url, name, company, blog, location, email, twitter_username, followers, following
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = (try? container.decode(Int.self, forKey: .id)) ?? 0
        name = (try? container.decode(String.self, forKey: .name)) ?? ""
        avatar_url = try? container.decode(String.self, forKey: .avatar_url)
        company = try? container.decode(String.self, forKey: .company)
        blog = try? container.decode(String.self, forKey: .blog)
        location = try? container.decode(String.self, forKey: .company)
        email = try? container.decode(String.self, forKey: .blog)
        twitter_username = try? container.decode(String.self, forKey: .twitter_username)
        followers = (try? container.decode(Int.self, forKey: .followers)) ?? 0
        following = (try? container.decode(Int.self, forKey: .following)) ?? 0
    }
}
