//
//  RepositorySectionData.swift
//  GithubSearch_MVVM+RxSwift
//
//  Created by 박승태 on 2023/02/10.
//

import RxDataSources

struct RepositorySectionData {
    var items: [Item]
}

extension RepositorySectionData: SectionModelType {
    typealias Item = Repository
    
    init(original: RepositorySectionData, items: [Repository]) {
        self = original
        self.items = items
    }
}
