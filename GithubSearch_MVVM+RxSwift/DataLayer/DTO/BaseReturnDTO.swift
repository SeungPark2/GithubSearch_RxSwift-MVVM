//
//  BaseReturnDTO.swift
//  GithubSearch_MVVM+RxSwift
//
//  Created by 박승태 on 2023/02/26.
//

import Foundation

struct BaseReturnDTO: Codable {
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case message
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        message = (try? container.decode(String.self, forKey: .message)) ?? ""
    }
}
