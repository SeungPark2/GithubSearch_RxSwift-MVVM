//
//  LicenseDTO.swift
//  GithubSearch_MVVM+RxSwift
//
//  Created by 박승태 on 2023/02/09.
//

import Foundation

struct LicenseDTO: Codable {
    let key: String
    let name: String
    let spdx_id: String
    let url: String
    let node_id: String
    
    enum CodingKeys: String, CodingKey {
        case key, name, spdx_id, url, node_id
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        key = (try? container.decode(String.self, forKey: .key)) ?? ""
        name = (try? container.decode(String.self, forKey: .name)) ?? ""
        spdx_id = (try? container.decode(String.self, forKey: .spdx_id)) ?? ""
        url = (try? container.decode(String.self, forKey: .url)) ?? ""
        node_id = (try? container.decode(String.self, forKey: .node_id)) ?? ""
    }
    
    init() {
        key = ""
        name = ""
        spdx_id = ""
        url = ""
        node_id = ""
    }
}
