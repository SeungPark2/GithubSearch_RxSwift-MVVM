//
//  TopicSectionData.swift
//  GithubSearch_MVVM+RxSwift
//
//  Created by 박승태 on 2023/02/20.
//

import RxDataSources

struct TopicSectionData {
    var items: [Item]
}

extension TopicSectionData: SectionModelType {
    typealias Item = String
    
    init(original: TopicSectionData, items: [String]) {
        self = original
        self.items = items
    }
}
