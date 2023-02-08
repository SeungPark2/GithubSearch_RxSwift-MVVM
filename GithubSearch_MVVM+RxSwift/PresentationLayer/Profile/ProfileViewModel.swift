//
//  ProfileViewModel.swift
//  GithubSearch_MVVM+RxSwift
//
//  Created by 박승태 on 2023/02/08.
//

import Foundation

final class ProfileViewModel: ViewModelType {
    
    // MARK: -- Properties
    
    private let useCase: ProfileUseCaseProtocol
    
    // MARK: -- Action
    
    struct Action {
    }
    
    // MARK: -- State
    
    struct State {
    }
    
    // MARK: -- Bind Properties
    
    // MARK: -- init
    
    init(useCase: ProfileUseCaseProtocol) {
        self.useCase = useCase
    }
}

// MARK: Bind

extension ProfileViewModel {
    
    func transform(from action: Action) -> State {
    }
}
