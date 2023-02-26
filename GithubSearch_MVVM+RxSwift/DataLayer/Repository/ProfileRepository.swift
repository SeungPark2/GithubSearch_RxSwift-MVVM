//
//  ProfileRepository.swift
//  GithubSearch_MVVM+RxSwift
//
//  Created by 박승태 on 2023/02/08.
//

import RxSwift

protocol ProfileRepositoryProtocol {
    func requestUserInfomation() -> Observable<UserInfomationDTO>
    func requestAddedStarRepository(page: Int) -> Observable<RepositorySearchResultDTO>
    func requestRemoveStarRepository(ownerName: String, repositoryName: String) -> Observable<BaseReturnDTO>
}

final class ProfileRepository: ProfileRepositoryProtocol {
    
    // MARK: -- Properties
    
    private let service: NetworkService<ProfileTarget>
    
    // MARK: -- Initalize
    
    init(service: NetworkService<ProfileTarget> = NetworkService<ProfileTarget>()) {
        self.service = service
    }
    
    // MARK: -- Methods
    
    func requestUserInfomation() -> Observable<UserInfomationDTO> {
        service.request(.requestUserInfomation)
    }
    
    func requestAddedStarRepository(page: Int) -> Observable<RepositorySearchResultDTO> {
        service.request(.searchAddedStarRepository(page: page))
    }
    
    func requestRemoveStarRepository(ownerName: String, repositoryName: String) -> Observable<BaseReturnDTO> {
        service.request(.removeStarRepository(ownerName: ownerName, repositoryName: repositoryName))
    }
}
