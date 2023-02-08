//
//  ViewModelType.swift
//  GithubSearch_MVVM+RxSwift
//
//  Created by 박승태 on 2023/02/08.
//

import Foundation

protocol ViewModelType {
    associatedtype Action
    associatedtype State
    
    func transform(from action: Action) -> State
}
