//
//  StringLiterals.swift
//  GithubSearch_MVVM+RxSwift
//
//  Created by 박승태 on 2023/02/15.
//

import Foundation

enum StringLiterals {
    enum Common: String {
        case ok                   = "확인"
        case cancel               = "취소"
    }
    
    enum Title: String {
        case search               = "search"
    }
    
    enum Placeholder: String {
        case keywordInput        = "검색어 입력"
    }
    
    enum Identifier: String {
        case searchBarTextField   = "searchBarTextField"
    }
    
    enum Key: String {
        case cancelButtonText     = "cancelButtonText"
    }
}
