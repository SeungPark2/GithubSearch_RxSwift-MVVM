//
//  GithubSearchRepository.swift
//  GithubSearch_MVVM+RxSwift
//
//  Created by 박승태 on 2023/02/08.
//

import Foundation

import RxSwift

protocol GithubSearchRepositoryProtocol: AnyObject {
    func searchRepository(with keyword: String, page: Int) -> Observable<RepositorySearchResultDTO>
}

final class GithubSearchRepository: GithubSearchRepositoryProtocol {
    
    // MARK: -- Properties
    
    private let service: NetworkService<GithubSearchRepositoryTarget>
    
    // MARK: -- Initalize
    
    init(service: NetworkService<GithubSearchRepositoryTarget> = NetworkService<GithubSearchRepositoryTarget>()) {
        self.service = service
    }
    
    // MARK: -- Methods
    
    func searchRepository(with keyword: String, page: Int) -> Observable<RepositorySearchResultDTO> {
        service.request(.searchRepository(keyword: keyword, page: page))
    }
}
