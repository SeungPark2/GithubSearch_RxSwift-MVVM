//
//  TopicCollectionViewCell.swift
//  GithubSearch_MVVM+RxSwift
//
//  Created by 박승태 on 2023/02/20.
//

import UIKit

import SnapKit
import Then

final class TopicCollectionViewCell: UICollectionViewCell {
    
    // MARK: -- Properties
    
    static let identifier: String = "TopicCollectionViewCell"
    
    // MARK: -- Initalize
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addViews()
        setUpViewsLayout()
        updateCornerRoundAtContentView()
        contentView.backgroundColor = .systemBlue
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: -- Life Cycle
    
    // MARK: -- Methods
    
    static func confiure(collectionView: UICollectionView, indexPath: IndexPath, topic: String) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopicCollectionViewCell.identifier, for: indexPath) as? TopicCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.updateContent(with: topic)
        return cell
    }
    
    private func updateContent(with topic: String) {
        topicNameLabel.text = topic
        topicNameLabel.sizeToFit()
    }
    
    func topicNameLabelSize() -> CGSize {
        topicNameLabel.bounds.size
    }
    
    // MARK: -- AddViews
    
    private func addViews() {
        contentView.addSubview(topicNameLabel)
    }
    
    // MARK: -- SetUpViewsLayout
    
    private func setUpViewsLayout() {
        topicNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(3)
            $0.leading.equalToSuperview().inset(5)
            $0.trailing.equalToSuperview().inset(5)
            $0.bottom.equalToSuperview().inset(3)
        }
        
        setNeedsLayout()
    }
    
    private func updateCornerRoundAtContentView() {
        contentView.round(radius: 4)
    }
    
    // MARK: -- UI
    
    private let topicNameLabel = UILabel().then {
        $0.textColor = Color.Gray.RGB204
        $0.font = .systemFont(ofSize: 14)
    }
}
