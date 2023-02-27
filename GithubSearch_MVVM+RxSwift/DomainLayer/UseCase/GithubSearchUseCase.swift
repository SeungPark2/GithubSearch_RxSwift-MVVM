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
    var limitResetDate: Driver<Date?> { get }
    
    func searchRepository(with keyword: String)
    func initializationPage()
    func initializationExceededLimit()
}

final class GithubSearchUseCase: GithubSearchUseCaseProtocol {
    
    // MARK: -- Properties
    
    var errMsg: Driver<String?>
    var repositories: Driver<[Repository]>
    var limitResetDate: Driver<Date?>
    
    private let repository: GithubSearchRepositoryProtocol
    private var errMsgRelay = PublishRelay<String?>()
    private var repositoriesRelay = BehaviorRelay<[Repository]>(value: [])
    private var limitResetDateRelay = BehaviorRelay<Date?>(value: nil)
    private var page: Int = 1
    private var isLastedPage: Bool = false
    private var isLoadingRepositories: Bool = false
    private var disposeBag = DisposeBag()
    
    // MARK: -- Initalize
    
    init(repository: GithubSearchRepositoryProtocol) {
        self.repository = repository
        errMsg = errMsgRelay.asDriver(onErrorJustReturn: nil)
        repositories = repositoriesRelay.asDriver(onErrorJustReturn: [])
        limitResetDate = limitResetDateRelay.asDriver(onErrorJustReturn: nil)
    }
    
    // MARK: -- Methods
    
    func searchRepository(with keyword: String) {
        guard !keyword.isEmpty, !isLoadingRepositories, !isLastedPage, limitResetDateRelay.value == nil else { return }
        
        isLoadingRepositories = true
        
        repository.searchRepository(with: keyword, page: page)
            .subscribe(
                onNext: { [weak self] repositorySearchResultDTO in
                    let repositories = self?.repositoriesRelay.value ?? []
                    self?.repositoriesRelay.accept(repositories + repositorySearchResultDTO.repositories.map { $0.toDomain() })
                    self?.isLoadingRepositories = false
                    self?.checkLastedPage(totalCount: repositorySearchResultDTO.total_count)
                    
                    if !(self?.isLastedPage ?? true) {
                        self?.increasePage()
                    }
                },
                onError: { [weak self] err in
                    self?.errMsgRelay.accept(self?.convertToString(err: err as? APIError))
                    self?.isLoadingRepositories = false
                }
            )
            .disposed(by: disposeBag)
    }
    
    func initializationPage() {
        isLastedPage = false
        page = 1
    }
    
    func initializationExceededLimit() {
        limitResetDateRelay.accept(nil)
    }
    
    private func checkLastedPage(totalCount: Int) {
        isLastedPage = page * 10 >= totalCount
    }
    
    private func increasePage() {
        page += 1
    }
    
    private func convertToString(err: APIError?) -> String {
        switch err {
        case .urlEncodingFail, .jsonEncodingFail, .jsonDecodingFail, .failed:
            return ErrorMessage.failed
        case .tokenEmpty:
            return ErrorMessage.needToken
        case .invaildToken(let limitResetDateInt):
            if let resetDateInt = limitResetDateInt, resetDateInt > 0 {
                limitResetDateRelay.accept(Date(timeIntervalSince1970: TimeInterval(integerLiteral: resetDateInt)))
            }
            
            return ErrorMessage.searchRateLimit
        case .serverNotConnected:
            return ErrorMessage.serverNotConnected
        default:
            return ErrorMessage.failed
        }
    }
}
