//
//  APIError.swift
//  GithubSearch_MVVM+RxSwift
//
//  Created by 박승태 on 2023/02/10.
//

import Foundation

enum APIError: Error {
    case urlEncodingError
    case jsonEncodingError
    case jsonDecodingError
    case invaildToken
    case failed(errCode: Int, message: String)
    case serverNotConnected
}

extension APIError {
    
    var description: String {
        switch self {
            case .urlEncodingError, .jsonEncodingError, .jsonDecodingError, .failed(_, _):
                return ErrorMessage.failed
            case .invaildToken:
                return ErrorMessage.invalidAPIToken
            case .serverNotConnected:
                return ErrorMessage.serverNotConnected
        }
    }
}
