//
//  GithubSearchUseCase.swift
//  GithubSearch_MVVM+RxSwift
//
//  Created by 박승태 on 2023/02/08.
//

import Foundation

protocol GithubSearchUseCaseProtocol: AnyObject {
    
}

final class GithubSearchUseCase: GithubSearchUseCaseProtocol {
    
    // MARK: -- Properties
    
    private let repository: GithubSearchRepositoryProtocol
    private let user: User
    
    // MARK: -- Initalize
    
    init(repository: GithubSearchRepositoryProtocol, user: User) {
        self.repository = repository
        self.user = user
    }
    
    // MARK: -- Methods
}
