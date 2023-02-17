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
    private var limitTimer: DispatchSourceTimer?
    private lazy var limitTime: Int = 0
    
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
        var limitTimerTime: Driver<String?>
    }
    
    // MARK: -- Bind Properties
    
    private var isHiddenLoadingView = BehaviorRelay(value: true)
    private var errMsg = PublishRelay<String?>()
    private var keyword = PublishRelay<String>()
    private var repositories = PublishRelay<[Repository]>()
    private var limitTimerTime = PublishRelay<String?>()
    
    // MARK: -- init
    
    init(useCase: GithubSearchUseCaseProtocol) {
        self.useCase = useCase
    }
    
    // MARK: -- Methods
    
    private func startLimitTimer() {
        limitTimer = DispatchSource.makeTimerSource(queue: DispatchQueue(label: "rateLimitTimer", qos: .userInitiated))
        limitTimer?.schedule(deadline: .now(), repeating: .seconds(1))
        limitTimer?.setEventHandler(handler: { [weak self] in
            self?.decreaseAndUpdateTimerTime()
        })
        limitTimer?.resume()
    }
    
    @objc
    private func decreaseAndUpdateTimerTime() {
        if limitTime > 0 {
            limitTime -= 1
            limitTimerTime.accept("\(limitTime)초 후 검색 가능합니다.")
            return
        }
        
        limitTimerTime.accept(nil)
        useCase.initializationExceededLimit()
        limitTimer?.cancel()
        limitTimer = nil
    }
    
    private func calculateTimeBetweenCurrentAndLimitResetDate(resetDate: Date) {
        let currentDate = Date()
        limitTime = Int(resetDate.timeIntervalSince(currentDate))
    }
}

extension GithubSearchViewModel {
    
    func transform(from action: Action) -> State {
        let state = State(
            isHiddenLoadingView: isHiddenLoadingView.asDriver(),
            errMsg: errMsg.asDriver(onErrorJustReturn: nil),
            keyword: keyword.asDriver(onErrorJustReturn: ""),
            repositories: repositories.asDriver(onErrorJustReturn: []),
            limitTimerTime: limitTimerTime.asDriver(onErrorJustReturn: nil)
        )
        bindUseCaseState()
        
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
    
    private func bindUseCaseState() {
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
        
        Observable.combineLatest(useCase.limitResetDate.asObservable(), useCase.errMsg.asObservable())
            .filter { $0 != nil && $1 == ErrorMessage.searchRateLimit }
            .bind { [weak self] limitResetDate, _ in
                guard let resetDate = limitResetDate else {
                    return
                }
                
                self?.calculateTimeBetweenCurrentAndLimitResetDate(resetDate: resetDate)
                self?.startLimitTimer()
            }
            .disposed(by: disposeBag)
    }
}
