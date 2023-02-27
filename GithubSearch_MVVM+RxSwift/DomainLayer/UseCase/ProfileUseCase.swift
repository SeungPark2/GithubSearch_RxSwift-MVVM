//
//  ProfileUseCase.swift
//  GithubSearch_MVVM+RxSwift
//
//  Created by 박승태 on 2023/02/08.
//

import RxCocoa
import RxSwift

protocol ProfileUseCaseProtocol {
    var errMsg: Driver<String?> { get }
    var user: Driver<User> { get }
    var starRepositories: Driver<[Repository]> { get }
    
    func refreshUserInfomationAndStarRepository()
    func loadMoreStarRepository()
    func removeStarRepository(index: Int)
    func initializationPage()
}

final class ProfileUseCase: ProfileUseCaseProtocol {
    
    // MARK: -- Properties
    
    var errMsg: Driver<String?>
    var user: Driver<User>
    var starRepositories: Driver<[Repository]>
    
    private let repository: ProfileRepositoryProtocol
    private var errMsgRelay = PublishRelay<String?>()
    private var userRelay = BehaviorRelay<User>(value: User.initailization())
    private var starRepositoriesRelay = BehaviorRelay<[Repository]>(value: [])
    private var page: Int = 1
    private var isLastedPage: Bool = false
    private var isLoading: Bool = false
    private var disposeBag = DisposeBag()
    
    // MARK: -- Initalize
    
    init(repository: ProfileRepositoryProtocol) {
        self.repository = repository
        errMsg = errMsgRelay.asDriver(onErrorJustReturn: nil)
        user = userRelay.asDriver(onErrorJustReturn: User.initailization())
        starRepositories = starRepositoriesRelay.asDriver(onErrorJustReturn: [])
    }
    
    // MARK: -- Methods
    
    func refreshUserInfomationAndStarRepository() {
        guard !isLoading, !isLastedPage else { return }
        
        isLoading = true
        
        Observable.zip(repository.requestUserInfomation(), repository.requestAddedStarRepository(page: page))
            .subscribe(
                onNext: { [weak self] userInfomationDTO, repositorySearchResultDTO in
                    self?.userRelay.accept(userInfomationDTO.toDomain())
                    self?.starRepositoriesRelay.accept(repositorySearchResultDTO.repositories.map { $0.toDomain() })
                    self?.isLoading = false
                    self?.checkLastedPage(totalCount: repositorySearchResultDTO.total_count)
                    
                    if !(self?.isLastedPage ?? true) {
                        self?.increasePage()
                    }
                },
                onError: { [weak self] err in
                    self?.errMsgRelay.accept(self?.convertToString(err: err as? APIError))
                    self?.isLoading = false
                }
            )
            .disposed(by: disposeBag)
    }
    
    func loadMoreStarRepository() {
        guard !isLoading, !isLastedPage else { return }
        
        isLoading = true
        
        repository.requestAddedStarRepository(page: page)
            .subscribe(
                onNext: { [weak self] repositorySearchResultDTO in
                    let repositories = self?.starRepositoriesRelay.value ?? []
                    self?.starRepositoriesRelay.accept(repositories + repositorySearchResultDTO.repositories.map { $0.toDomain() })
                    self?.isLoading = false
                    self?.checkLastedPage(totalCount: repositorySearchResultDTO.total_count)
                    
                    if !(self?.isLastedPage ?? true) {
                        self?.increasePage()
                    }
                },
                onError: { [weak self] err in
                    self?.errMsgRelay.accept(self?.convertToString(err: err as? APIError))
                    self?.isLoading = false
                }
            )
            .disposed(by: disposeBag)
    }
    
    func removeStarRepository(index: Int) {
        guard !isLoading else { return }
        
        isLoading = true
        
        repository.requestRemoveStarRepository(ownerName: userRelay.value.name, repositoryName: starRepositoriesRelay.value[index].name)
            .subscribe(
                onNext: { [weak self] _ in
                    self?.starRepositoriesRelay.accept(self?.removeRepository(at: index) ?? [])
                    self?.isLoading = false
                },
                onError: { [weak self] err in
                    self?.errMsgRelay.accept(self?.convertToString(err: err as? APIError))
                    self?.isLoading = false
                }
            )
            .disposed(by: disposeBag)
    }
    
    func initializationPage() {
        isLastedPage = false
        page = 1
    }
    
    private func checkLastedPage(totalCount: Int) {
        isLastedPage = page * 10 >= totalCount
    }
    
    private func increasePage() {
        page += 1
    }
    
    private func removeRepository(at index: Int) -> [Repository] {
        var copyRepository = starRepositoriesRelay.value
        copyRepository.remove(at: index)
        return copyRepository
    }
    
    private func convertToString(err: APIError?) -> String {
        switch err {
        case .urlEncodingFail, .jsonEncodingFail, .jsonDecodingFail, .failed, .invaildToken:
            return ErrorMessage.failed
        case .tokenEmpty:
            return ErrorMessage.needToken
        case .serverNotConnected:
            return ErrorMessage.serverNotConnected
        default:
            return ErrorMessage.failed
        }
    }
}
