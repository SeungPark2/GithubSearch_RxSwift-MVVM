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
    private var repositoriesRelay = PublishRelay<[Repository]>()
    private var page: Int = 1
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
        repository.searchRepository(with: keyword, page: page)
            .subscribe(
                onNext: { repositoryDTO in
                    
                },
                onError: { err in
                    
                }
            )
            .disposed(by: disposeBag)
    }
}
