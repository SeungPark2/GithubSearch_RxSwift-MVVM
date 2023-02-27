//
//  ProfileViewModel.swift
//  GithubSearch_MVVM+RxSwift
//
//  Created by 박승태 on 2023/02/08.
//

import RxSwift
import RxCocoa

final class ProfileViewModel: ViewModelType {
    
    // MARK: -- Properties
    
    private let useCase: ProfileUseCaseProtocol
    private var disposeBag = DisposeBag()
    
    // MARK: -- Action
    
    struct Action {
        let navigationRightButtonDidTap: Driver<Void>
        let loginButtonDidTap: Driver<Void>
        let refresh: Driver<Void>
        let loadNextPage: Driver<Void>
        let removeStarButtonDidTap: Driver<Int>
    }
    
    // MARK: -- State
    
    struct State {
        let isHiddenLoadingView: Driver<Bool>
        let errMsg: Driver<String?>
        let userInfo: Driver<User>
        let starRepositories: Driver<[Repository]>
    }
    
    // MARK: -- Bind Properties
    
    private var isHiddenLoadingView = BehaviorRelay<Bool>(value: true)
    private var errMsg = PublishRelay<String?>()
    private var userInfo = PublishRelay<User>()
    private var starRepositories = PublishRelay<[Repository]>()
    
    // MARK: -- init
    
    init(useCase: ProfileUseCaseProtocol) {
        self.useCase = useCase
    }
}

// MARK: Bind

extension ProfileViewModel {
    
    func transform(from action: Action) -> State {
        let state = State(
            isHiddenLoadingView: isHiddenLoadingView.asDriver(),
            errMsg: errMsg.asDriver(onErrorJustReturn: nil),
            userInfo: userInfo.asDriver(onErrorJustReturn: User.initailization()),
            starRepositories: starRepositories.asDriver(onErrorJustReturn: [])
        )
        bindState()
        
        action.refresh
            .asObservable()
            .bind { [weak self] in
                self?.isHiddenLoadingView.accept(false)
                self?.useCase.initializationPage()
                self?.useCase.refreshUserInfomationAndStarRepository()
            }
            .disposed(by: disposeBag)
        
        action.loadNextPage
            .asObservable()
            .bind { [weak self] in
                self?.useCase.loadMoreStarRepository()
            }
            .disposed(by: disposeBag)
        
        action.removeStarButtonDidTap
            .asObservable()
            .bind{ [weak self] index in
                self?.isHiddenLoadingView.accept(false)
                self?.useCase.removeStarRepository(index: index)
            }
            .disposed(by: disposeBag)
        
        return state
    }
    
    private func bindState() {
        useCase.errMsg
            .filter { $0 != nil }
            .asObservable()
            .bind { [weak self] errMsg in
                self?.isHiddenLoadingView.accept(true)
                self?.errMsg.accept(errMsg)
            }
            .disposed(by: disposeBag)
        
        useCase.user
            .filter { !$0.name.isEmpty }
            .asObservable()
            .bind { [weak self] userInfo in
                self?.userInfo.accept(userInfo)
            }
            .disposed(by: disposeBag)
        
        useCase.starRepositories
            .asObservable()
            .bind { [weak self] repositories in
                self?.isHiddenLoadingView.accept(true)
                self?.starRepositories.accept(repositories)
            }
            .disposed(by: disposeBag)
    }
}
