//
//  GithubSearchReactor.swift
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
    private var disposeBag = DisposeBag()
    
    // MARK: -- Action
    
    struct Action {
        let navigationRightButtonDidTap: Driver<Void>
        let typingKeyword: Driver<String>
        let searchDidTap: Driver<String>
        let cancelDidTap: Driver<Void>
        let loadNextPage: Driver<String>
    }
    
    // MARK: -- State
    
    struct State {
        var isHiddenLoadingView: Driver<Bool>
        var errMsg: Driver<String?>
        var keyword: Driver<String>
        var repositories: Driver<[Repository]>
    }
    
    // MARK: -- Bind Properties
    
    private var isHiddenLoadingView = BehaviorRelay(value: true)
    private var errMsg = PublishRelay<String?>()
    private var keyword = PublishRelay<String>()
    private var repositories = PublishRelay<[Repository]>()
    
    // MARK: -- init
    
    init(useCase: GithubSearchUseCaseProtocol) {
        self.useCase = useCase
    }
}

// MARK: Bind

extension GithubSearchViewModel {
    
    func transform(from action: Action) -> State {
        let state = State(
            isHiddenLoadingView: isHiddenLoadingView.asDriver(),
            errMsg: errMsg.asDriver(onErrorJustReturn: nil),
            keyword: keyword.asDriver(onErrorJustReturn: ""),
            repositories: repositories.asDriver(onErrorJustReturn: [])
        )
        
        action.typingKeyword
            .asObservable()
            .bind { [weak self] keyword in
                self?.keyword.accept(keyword)
            }
            .disposed(by: disposeBag)
        
        action.searchDidTap
            .asObservable()
            .bind { [weak self] keyword in
                self?.isHiddenLoadingView.accept(false)
                self?.useCase.searchRepository(with: keyword)
            }
            .disposed(by: disposeBag)
        
        action.loadNextPage
            .asObservable()
            .bind { [weak self] keyword in
                self?.useCase.searchRepository(with: keyword)
            }
            .disposed(by: disposeBag)
        
        return state
    }
    
    private func bindState() {
        useCase.errMsg
            .filter { $0 != nil }
            .asObservable()
            .bind { [weak self] message in
                self?.isHiddenLoadingView.accept(true)
                self?.errMsg.accept(message)
            }
            .disposed(by: disposeBag)
        
        useCase.repositories
            .asObservable()
            .bind { [weak self] repositories in
                self?.isHiddenLoadingView.accept(true)
                self?.repositories.accept(repositories)
            }
            .disposed(by: disposeBag)
    }
}
