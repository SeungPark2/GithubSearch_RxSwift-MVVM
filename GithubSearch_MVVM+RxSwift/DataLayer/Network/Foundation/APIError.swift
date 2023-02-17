//
//  APIError.swift
//  GithubSearch_MVVM+RxSwift
//
//  Created by 박승태 on 2023/02/10.
//

import Foundation

enum APIError: Error {
    case urlEncodingFail
    case jsonEncodingFail
    case jsonDecodingFail
    case tokenEmpty
    case invaildToken(limitResetDate: Int64?)
    case failed(errCode: Int, message: String)
    case serverNotConnected
}

extension APIError {
    
    var description: String {
        switch self {
            case .urlEncodingFail, .jsonEncodingFail, .jsonDecodingFail, .failed:
                return ErrorMessage.failed
            case .tokenEmpty:
                return ErrorMessage.needToken
            case .invaildToken:
                return ErrorMessage.invalidToken
            case .serverNotConnected:
                return ErrorMessage.serverNotConnected
        }
    }
}
