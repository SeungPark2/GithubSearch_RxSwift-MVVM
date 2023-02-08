//
//  GithubSearchViewModel.swift
//  GithubSearch_MVVM+RxSwift
//
//  Created by 박승태 on 2023/02/08.
//

import Foundation

import RxSwift
import RxCocoa

final class GithubSearchViewModel: ViewModelType {
    
    // MARK: -- Properties
    
    private let useCase: GithubSearchUseCaseProtocol
    
    // MARK: -- Action
    
    struct Action {
    }
    
    // MARK: -- State
    
    struct State {
    }
    
    // MARK: -- Bind Properties
    
    // MARK: -- init
    
    init(useCase: GithubSearchUseCaseProtocol) {
        self.useCase = useCase
    }
}

// MARK: Bind

extension GithubSearchViewModel {
    
    func transform(from action: Action) -> State {
    }
}
