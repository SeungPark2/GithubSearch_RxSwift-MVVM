//
//  GithubSearchRepository.swift
//  GithubSearch_MVVM+RxSwift
//
//  Created by 박승태 on 2023/02/08.
//

import Foundation

import RxSwift

protocol GithubSearchRepositoryProtocol: AnyObject {
    func searchRepository(with keyword: String, page: Int) -> Observable<RepositoryDTO>
}

final class GithubSearchRepository: GithubSearchRepositoryProtocol {
    
    // MARK: -- Properties
    
    // MARK: -- Initalize
    
    // MARK: -- Methods
    
    func searchRepository(with keyword: String, page: Int) -> Observable<RepositoryDTO> {
    }
}
