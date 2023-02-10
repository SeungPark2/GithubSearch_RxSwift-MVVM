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
    
    // API
    
    static let invalidAPIToken:  String                   = "권한이 허용되지 않았습니다. \n다시 로그인해주세요."
    static let failed: String                             = "예기치 못한 오류가 발생했습니다. \n잠시 후 다시 시도해주세요."
    static let serverNotConnected: String                 = "일시적으로 이용이 불가능합니다. \n잠시 후 다시 시도해주세요."
}
