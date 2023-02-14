//
//  GithubSearchUseCase.swift
//  GithubSearch_MVVM+RxSwift
//
//  Created by 박승태 on 2023/02/08.
//

import Foundation

import RxSwift
import RxCocoa

protocol GithubSearchUseCaseProtocol: AnyObject {
    var errMsg: Driver<String?> { get }
    var repositories: Driver<[Repository]> { get }
    
    func searchRepository(with keyword: String)
}

final class GithubSearchUseCase: GithubSearchUseCaseProtocol {
    
    // MARK: -- Properties
    
    var errMsg: Driver<String?>
    var repositories: Driver<[Repository]>
    
    private let repository: GithubSearchRepositoryProtocol
    private let user: User
    private var errMsgRelay = PublishRelay<String?>()
    private var repositoriesRelay = BehaviorRelay<[Repository]>(value: [])
    private var page: Int = 1
    private var isLastedPage: Bool = false
    private var isLoadingRepositories: Bool = false
    private var disposeBag = DisposeBag()
    
    // MARK: -- Initalize
    
    init(repository: GithubSearchRepositoryProtocol, user: User) {
        self.repository = repository
        self.user = user
        errMsg = errMsgRelay.asDriver(onErrorJustReturn: nil)
        repositories = repositoriesRelay.asDriver(onErrorJustReturn: [])
    }
    
    // MARK: -- Methods
    
    func searchRepository(with keyword: String) {
        guard !keyword.isEmpty, !isLoadingRepositories, !isLastedPage else { return }
        
        isLoadingRepositories = true
        
        repository.searchRepository(with: keyword, page: page)
            .subscribe(
                onNext: { [weak self] repositorySearchResultDTO in
                    let repositories = self?.repositoriesRelay.value ?? []
                    self?.repositoriesRelay.accept(repositories + repositorySearchResultDTO.repositories.map { $0.toDomain() })
                    self?.isLoadingRepositories = false
                    self?.checkLastedPage(totalCount: repositorySearchResultDTO.total_count)
                },
                onError: { [weak self] err in
                    self?.errMsgRelay.accept((err as? APIError)?.description)
                    self?.isLoadingRepositories = false
                }
            )
            .disposed(by: disposeBag)
    }
    
    private func checkLastedPage(totalCount: Int) {
        isLastedPage = page * 10 >= totalCount
    }
}
