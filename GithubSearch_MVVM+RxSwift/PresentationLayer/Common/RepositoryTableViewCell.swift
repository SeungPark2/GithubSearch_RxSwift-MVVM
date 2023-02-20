//
//  RepositoryCell.swift
//  GithubSearch_MVVM+RxSwift
//
//  Created by 박승태 on 2023/02/08.
//

import UIKit

import SnapKit
import SkeletonView
import Then
import Kingfisher
import RxDataSources
import RxCocoa
import RxSwift

final class RepositoryTableViewCell: UITableViewCell {
    
    // MARK: -- Properties
    
    static let identifier: String = "RepositoryTableViewCell"
    private var topics = PublishRelay<[String]>()
    private let topicyDataSource = RxCollectionViewSectionedReloadDataSource<TopicSectionData> { dataSource, collectionView, indexPath, topic in
        TopicCollectionViewCell.confiure(collectionView: collectionView, indexPath: indexPath, topic: topic)
    }
    private let disposeBag = DisposeBag()
    
    // MARK: -- Initalize
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addViews()
        setUpViewsLayout()
        updateViewsCornerRound()
        selectionStyle = .none
        bind()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: -- Life Cycle
 
    // MARK: -- Methods
    
    static func confiure(tableView: UITableView, indexPath: IndexPath, repository: Repository) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RepositoryTableViewCell.identifier, for: indexPath) as? RepositoryTableViewCell else {
            return UITableViewCell()
        }
        
        cell.updateContents(with: repository)
        return cell
    }
    
    private func updateContents(with repository: Repository) {
        downloadImage(with: repository.owner.profileImageURL)
        repositoryAndOwnerNameLabel.text = repository.nameWithOwnerName
        repositoryDescriptionLabel.text = repository.description
        // ISSUE - Topic CollectionView Height calculation
//        topics.accept(repository.topics)
//        repository.topics.isEmpty ? hideTopicCollectViewWhenTopicsEmpty() : showTopicCollectViewWhenTopicsNotEmpty()
        hideTopicCollectViewWhenTopicsEmpty()
        starCountLabel.text = "\(repository.starCount)"
        languageLabel.text = repository.language
        licenseLabel.text = repository.license.name
        updateDateLabel.text = repository.updatedTime.description
    }
    
    private func downloadImage(with imageURL: String) {
        KF.url(URL(string: imageURL))
            .loadDiskFileSynchronously()
            .cacheMemoryOnly()
            .fade(duration: 0.25)
            .roundCorner(radius: .widthFraction(20))
            .onFailure { [weak self] error in
                self?.ownerImageView.image = Image.Book.closeFill
            }
            .set(to: ownerImageView)
    }
    
    private func hideTopicCollectViewWhenTopicsEmpty() {
        topicCollectView.snp.updateConstraints {
            $0.height.equalTo(0)
        }
        
        setNeedsLayout()
    }
    
    private func showTopicCollectViewWhenTopicsNotEmpty() {
        topicCollectView.snp.updateConstraints {
            $0.height.equalTo(topicCollectView.contentSize.height)
        }
        
        setNeedsLayout()
    }
    
    // MARK: -- AddViews
    
    private func addViews() {
        contentView.addSubViews(
            ownerImageView, repositoryAndOwnerNameLabel, starButton,
            repositoryDescriptionLabel,
            topicCollectView,
            starCountImageView, starCountLabel, languageColorView, languageLabel, licenseLabel, updateDateLabel
        )
    }
    
    // MARK: -- SetUpViewsLayout
    
    private func setUpViewsLayout() {
        ownerImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.equalToSuperview().inset(10)
            $0.width.height.equalTo(20)
        }
        
        repositoryAndOwnerNameLabel.snp.makeConstraints {
            $0.centerY.equalTo(ownerImageView)
            $0.leading.equalTo(ownerImageView.snp.trailing).offset(12)
            $0.height.equalTo(20)
        }
        
        starButton.snp.makeConstraints {
            $0.centerY.equalTo(repositoryAndOwnerNameLabel)
            $0.trailing.equalToSuperview().inset(20)
            $0.leading.equalTo(repositoryAndOwnerNameLabel.snp.trailing).offset(10)
            $0.width.height.equalTo(30)
        }
        
        repositoryDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(repositoryAndOwnerNameLabel.snp.bottom).offset(4)
            $0.leading.equalTo(repositoryAndOwnerNameLabel)
            $0.trailing.equalTo(starButton)
            $0.height.greaterThanOrEqualTo(15)
        }
        
        topicCollectView.snp.makeConstraints {
            $0.top.equalTo(repositoryDescriptionLabel.snp.bottom).offset(4)
            $0.leading.equalTo(repositoryDescriptionLabel)
            $0.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(0)
        }
        
        starCountImageView.snp.makeConstraints {
            $0.top.equalTo(topicCollectView.snp.bottom).offset(4)
            $0.leading.equalTo(repositoryDescriptionLabel)
            $0.bottom.equalToSuperview().inset(20)
            $0.width.height.equalTo(16)
        }
        
        starCountLabel.snp.makeConstraints {
            $0.centerY.equalTo(starCountImageView)
            $0.leading.equalTo(starCountImageView.snp.trailing).offset(4)
            $0.width.lessThanOrEqualTo(40)
        }
        
        languageColorView.snp.makeConstraints {
            $0.centerY.equalTo(starCountLabel)
            $0.leading.equalTo(starCountLabel.snp.trailing).offset(10)
            $0.width.height.equalTo(16)
        }
        
        languageLabel.snp.makeConstraints {
            $0.centerY.equalTo(languageColorView)
            $0.leading.equalTo(languageColorView.snp.trailing).offset(4)
        }
        
        licenseLabel.snp.makeConstraints {
            $0.centerY.equalTo(languageLabel)
            $0.leading.equalTo(languageLabel.snp.trailing).offset(10)
        }
        
        updateDateLabel.snp.makeConstraints {
            $0.centerY.equalTo(licenseLabel)
            $0.leading.equalTo(licenseLabel.snp.trailing).offset(10)
            $0.trailing.greaterThanOrEqualToSuperview().inset(20)
        }
        
        setNeedsLayout()
    }
    
    private func updateViewsCornerRound() {
        ownerImageView.round()
        languageColorView.round()
    }
    
    // MARK: -- UI
    
    private let ownerImageView = UIImageView()
    
    private let repositoryAndOwnerNameLabel = UILabel().then {
        $0.textColor = Color.Gray.RGB204
        $0.font = .systemFont(ofSize: 16, weight: .medium)
    }
    
    private let starButton = UIButton().then {
        $0.setImage(Image.Star.empty, for: .normal)
        $0.tintColor = .yellow
    }
    
    private let repositoryDescriptionLabel = UILabel().then {
        $0.textColor = Color.Gray.RGB173
        $0.font = .systemFont(ofSize: 14, weight: .medium)
        $0.numberOfLines = 0
    }
    
    private lazy var topicCollectView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.minimumLineSpacing = 3
        layout.minimumInteritemSpacing = 5
        layout.sectionInset = UIEdgeInsets(top: 5, left: 3, bottom: 5, right: 3)
        
        $0.collectionViewLayout = layout
        $0.isScrollEnabled = false
        $0.register(TopicCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: TopicCollectionViewCell.identifier)
        
        if let collectionViewLayout = $0.collectionViewLayout as? UICollectionViewFlowLayout {
            collectionViewLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
    }
    
    private let starCountImageView = UIImageView().then {
        $0.image = Image.Star.fill
        $0.tintColor = .yellow
    }
    
    private let starCountLabel = UILabel().then {
        $0.textColor = Color.Gray.RGB154
        $0.font = .systemFont(ofSize: 12)
    }
    
    private let languageColorView = UIView()
    
    private let languageLabel = UILabel().then {
        $0.textColor = Color.Gray.RGB154
        $0.font = .systemFont(ofSize: 12)
    }
    
    private let licenseLabel = UILabel().then {
        $0.textColor = Color.Gray.RGB154
        $0.font = .systemFont(ofSize: 12)
    }
    
    private let updateDateLabel = UILabel().then {
        $0.textColor = Color.Gray.RGB154
        $0.font = .systemFont(ofSize: 12)
    }
}

extension RepositoryTableViewCell {
    
    private func bind() {
        topics
            .map { [TopicSectionData(items: $0)] }
            .bind(to: topicCollectView.rx.items(dataSource: topicyDataSource))
            .disposed(by: disposeBag)
    }
}
