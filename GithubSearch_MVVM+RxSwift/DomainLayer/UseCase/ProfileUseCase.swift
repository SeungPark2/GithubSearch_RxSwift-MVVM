//
//  ProfileUseCase.swift
//  GithubSearch_MVVM+RxSwift
//
//  Created by 박승태 on 2023/02/08.
//

import Foundation

protocol ProfileUseCaseProtocol {
    
}

final class ProfileUseCase: ProfileUseCaseProtocol {
    
    // MARK: -- Properties
    
    private let repository: ProfileRepositoryProtocol
    private let user: User
    
    // MARK: -- Initalize
    
    init(repository: ProfileRepositoryProtocol, user: User) {
        self.repository = repository
        self.user = user
    }
    
    // MARK: -- Methods
}
