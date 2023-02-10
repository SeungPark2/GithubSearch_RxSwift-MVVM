//
//  BaseResponse.swift
//  GithubSearch_MVVM+RxSwift
//
//  Created by 박승태 on 2023/02/10.
//

import Foundation

import RxSwift

protocol NetworkServiceType: AnyObject {
    associatedtype Target: TargetType
    
    func request<T: Decodable>(_ target: Target) -> Observable<T>
}

class NetworkService<Target: TargetType>: NetworkServiceType, APILog {
//    private let session: URLSessionType
//    
//    init(session: URLSessionType = URLSession.shared) {
//        self.session = session
//    }
    
    func request<T: Decodable>(_ target: Target) -> Observable<T> {
        var urlString = target.baseURL + target.path
        
        if target.method == .GET && !target.queries.isEmpty {
            let queryArray = target.queries.map { key, value in
                "\(key)=\(value)"
            }
            let queryString = "?" + queryArray.joined(separator: "&")
            urlString += queryString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        }
        
        guard let url = URL(string: urlString) else {
            return .error(APIError.urlEncodingError)
        }
        
        var urlRequest = createURLRequest(url: url, target: target)
        
        if target.method != .GET && !target.params.isEmpty {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: target.params, options: [])
            } catch {
                return .error(APIError.jsonEncodingError)
            }
        }
        
        return URLSession.shared.rx.response(request: urlRequest)
            .map { [weak self] httpResponse, data in
                
                self?.printRequestInfo(target: target, data: data, response: httpResponse)
            
                guard let decodeData = try? JSONDecoder().decode(T.self, from: data) else {
                    throw APIError.jsonDecodingError
                }
                
                guard 200..<300 ~= httpResponse.statusCode else {
                    guard 500..<600 ~= httpResponse.statusCode else {
                        throw APIError.failed(errCode: httpResponse.statusCode, message: "")
                    }
                    throw APIError.serverNotConnected
                }
                
                return decodeData
            }
    }
    
    private func createURLRequest(url: URL, target: Target) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = target.method.rawValue
        request.allHTTPHeaderFields = target.headers
        return request
    }
}
