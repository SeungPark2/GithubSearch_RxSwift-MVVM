//
//  TargetType.swift
//  GithubSearch_MVVM+RxSwift
//
//  Created by 박승태 on 2023/02/10.
//

import Foundation

protocol TargetType {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var sampleData: Data { get }
    var queries: [String: Any] { get }
    var params: [String: Any] { get }
    var headers: [String: String] { get }
}

extension TargetType {
    var baseURL: String {
        API.Server.base
    }
    
    var sampleData: Data {
        Data()
    }
    
    var queries: [String: Any] {
        [:]
    }
    
    var params: [String: Any] {
        [:]
    }
}
