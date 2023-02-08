//
//  RepositoryCell.swift
//  GithubSearch_MVVM+RxSwift
//
//  Created by 박승태 on 2023/02/08.
//

import UIKit

import SnapKit
import Then
import Kingfisher

final class RepositoryTableViewCell: UITableViewCell {
    
    // MARK: -- Properties
    
    static let identifier: String = "RepositoryTableViewCell"
    
    // MARK: -- Initalize
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addViews()
        setUpViewsLayout()
        updateViewsCornerRound()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: -- Life Cycle
    
    // MARK: -- Methods
    
    func updateContents() {
        
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
    
    // MARK: -- AddViews
    
    private func addViews() {
        addSubViews(
            ownerImageView, repositoryAndOwnerNameLabel, starButton,
            repositoryDescriptionLabel,
            starCountImageView, starCountLabel, languageColorView, languageLabel, licenseLabel, updateDateLabel
        )
    }
    
    // MARK: -- SetUpViewsLayout
    
    private func setUpViewsLayout() {
        ownerImageView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(20)
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
            $0.width.height.equalTo(30)
        }
        
        repositoryDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(repositoryAndOwnerNameLabel.snp.bottom).offset(4)
            $0.leading.equalTo(repositoryAndOwnerNameLabel)
            $0.trailing.equalTo(starButton)
            $0.height.greaterThanOrEqualTo(15)
        }
        
        starCountImageView.snp.makeConstraints {
            $0.top.equalTo(repositoryDescriptionLabel.snp.bottom).offset(16)
            $0.leading.equalTo(repositoryDescriptionLabel)
            $0.bottom.equalToSuperview().inset(20)
            $0.width.height.equalTo(16)
        }
        
        starCountLabel.snp.makeConstraints {
            $0.centerY.equalTo(starCountImageView)
            $0.leading.equalTo(starCountLabel.snp.trailing).offset(4)
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
        
        layoutIfNeeded()
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
