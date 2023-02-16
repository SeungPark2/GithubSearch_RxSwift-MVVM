//
//  Strings.swift
//  GithubSearch_MVVM+RxSwift
//
//  Created by 박승태 on 2023/02/11.
//

import Foundation

struct ErrorMessage {
    static let failedAddStarRepository: String           = "스타 등록을 실패했습니다. \n다시 시도해주세요."
    static let failedRemoveStarRepository: String        = "스타 해제를 실패했습니다. \n다시 시도해주세요."
    
    static let searchRateLimit: String                   = "현재 너무 잦은 검색으로 제한되었습니다. (30초 후 다시 시도해주세요.)\n" +
                                                           "로그인 후 이용하시면 더 많은 검색을 할 수 있습니다."
    
    // API
    
    static let needToken: String                         = "로그인 후 이용해주세요."
    static let invalidToken: String                      = "접근이 제한되었습니다. \n다시 로그인해주세요."
    static let failed: String                            = "예기치 못한 오류가 발생했습니다. \n잠시 후 다시 시도해주세요."
    static let serverNotConnected: String                = "일시적으로 이용이 불가능합니다. \n잠시 후 다시 시도해주세요."
}
