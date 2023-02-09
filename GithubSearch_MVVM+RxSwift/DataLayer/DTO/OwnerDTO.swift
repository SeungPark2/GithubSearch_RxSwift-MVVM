//
//  OwnerDTO.swift
//  GithubSearch_MVVM+RxSwift
//
//  Created by 박승태 on 2023/02/09.
//

import Foundation

struct OwnerDTO: Codable {
    let id: Int
    let login: String
    let node_id: String
    let avatar_url: String
    let gravatar_id: String
    let url: String
    let html_url: String
    let followers_url: String
    let following_url: String
    let gists_url: String
    let starred_url: String
    let subscriptions_url: String
    let organizations_url: String
    let repos_url: String
    let events_url: String
    let received_events_url: String
    let type: String
    let site_admin: Bool
    
    enum CodingKeys: String, CodingKey {
        case id, login, node_id, avatar_url, gravatar_id, url, html_url, followers_url, following_url, gists_url, starred_url,
             subscriptions_url, organizations_url, repos_url, events_url, received_events_url, type, site_admin
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = (try? container.decode(Int.self, forKey: .id)) ?? 0
        login = (try? container.decode(String.self, forKey: .login)) ?? ""
        node_id = (try? container.decode(String.self, forKey: .node_id)) ?? ""
        avatar_url = (try? container.decode(String.self, forKey: .avatar_url)) ?? ""
        gravatar_id = (try? container.decode(String.self, forKey: .gravatar_id)) ?? ""
        url = (try? container.decode(String.self, forKey: .url)) ?? ""
        html_url = (try? container.decode(String.self, forKey: .html_url)) ?? ""
        followers_url = (try? container.decode(String.self, forKey: .followers_url)) ?? ""
        following_url = (try? container.decode(String.self, forKey: .following_url)) ?? ""
        gists_url = (try? container.decode(String.self, forKey: .gists_url)) ?? ""
        starred_url = (try? container.decode(String.self, forKey: .starred_url)) ?? ""
        subscriptions_url = (try? container.decode(String.self, forKey: .subscriptions_url)) ?? ""
        organizations_url = (try? container.decode(String.self, forKey: .organizations_url)) ?? ""
        repos_url = (try? container.decode(String.self, forKey: .repos_url)) ?? ""
        events_url = (try? container.decode(String.self, forKey: .events_url)) ?? ""
        received_events_url = (try? container.decode(String.self, forKey: .received_events_url)) ?? ""
        type = (try? container.decode(String.self, forKey: .type)) ?? ""
        site_admin = (try? container.decode(Bool.self, forKey: .site_admin)) ?? false
    }
    
    init() {
        id = 0
        login = ""
        node_id = ""
        avatar_url = ""
        gravatar_id = ""
        url = ""
        html_url = ""
        followers_url = ""
        following_url = ""
        gists_url = ""
        starred_url = ""
        subscriptions_url = ""
        organizations_url = ""
        repos_url = ""
        events_url = ""
        received_events_url = ""
        type = ""
        site_admin = false
    }
}
