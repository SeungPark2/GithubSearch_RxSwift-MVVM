//
//  GithubSearchViewController.swift
//  GithubSearch_MVVM+RxSwift
//
//  Created by 박승태 on 2023/02/07.
//

import UIKit

import SnapKit
import Then
import RxDataSources
import RxSwift
import RxCocoa

final class GithubSearchViewController: UIViewController {
    
    // MARK: -- Properties
    
    private let viewModel: GithubSearchViewModel
    private let disposeBag = DisposeBag()
    private let repositoryDataSource = RxTableViewSectionedReloadDataSource<RepositorySectionData>(
        configureCell: { dataSource, tableView, indexPath, repository in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: RepositoryTableViewCell.identifier, for: indexPath) as? RepositoryTableViewCell else {
                return UITableViewCell()
            }
            
            cell.updateContents(with: repository)
            return cell
        }
    )
    
    // MARK: -- Initalize
    
    init(viewModel: GithubSearchViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -- Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        addViews()
        setUpViewsLayout()
        updateNavigationTiTle()
        setUpNavigationBarAndTabBar()
        view.backgroundColor = Color.DarkGray.RGB64
        bindViewModel()
    }
    
    // MARK: -- Methods
    
    private func updateNavigationTiTle() {
        navigationItem.title = StringLiterals.Title.search
    }
    
    private func setUpNavigationBarAndTabBar() {
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        tabBarController?.tabBar.isTranslucent = true
        tabBarController?.tabBar.backgroundImage = UIImage()
        tabBarController?.tabBar.shadowImage = UIImage()
    }
    
    // MARK: -- AddViews
    
    private func addViews() {
        navigationController?.navigationItem.rightBarButtonItem = navigationRightLoginButton
        navigationItem.searchController = searchController
        view.addSubViews(
            repositoryTableView, loadingIndicatorView
        )
    }
    
    // MARK: -- SetUpViewsLayout
    
    private func setUpViewsLayout() {
        repositoryTableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        loadingIndicatorView.snp.makeConstraints {
            $0.center.equalTo(repositoryTableView)
        }
        
        view.setNeedsLayout()
    }
    
    // MARK: -- UI
    
    private let navigationRightLoginButton = UIBarButtonItem().then {
        $0.image = Image.LoginLogout.login
        $0.tintColor = .white
    }
    
    private let searchController = UISearchController(searchResultsController: nil).then {
        $0.searchBar.placeholder = StringLiterals.Placeholder.keywordInput
        $0.searchBar.setValue(StringLiterals.Common.cancel, forKey: StringLiterals.Key.cancelButtonText)
        $0.searchBar.tintColor = .black
        $0.searchBar.searchTextField.leftView?.tintColor = .lightGray
        $0.searchBar.searchTextField.textColor = .black
        $0.searchBar.searchTextField.accessibilityIdentifier = StringLiterals.Identifier.searchBarTextField
    }
    
    private let repositoryTableView = UITableView().then {
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 100
        $0.separatorInset = .init(top: 0, left: 10, bottom: 0, right: 20)
        $0.register(RepositoryTableViewCell.self, forCellReuseIdentifier: RepositoryTableViewCell.identifier)
    }
    
    private let loadingIndicatorView = UIActivityIndicatorView().then {
        $0.style = .large
        $0.tintColor = .white
    }
}

// MARK: -- Bind ViewModel

extension GithubSearchViewController {
    
    private func bindViewModel() {
        let searchDidTap = searchController.searchBar.rx.searchButtonClicked.map { [weak self] _ in
            self?.searchController.searchBar.searchTextField.text ?? ""
        }.asDriver(onErrorJustReturn: "")
        
        let loadNextPage = repositoryTableView.rx.prefetchRows
            .compactMap(\.last?.row)
            .withUnretained(self)
            .filter { vc, row in
                return (row + 1) % 10 == 0 || row == (vc.repositoryDataSource.sectionModels.first?.items.count ?? 1) - 1
            }
            .map { [weak self] _ in
                self?.searchController.searchBar.searchTextField.text ?? ""
            }.asDriver(onErrorJustReturn: "")
        
        let action = GithubSearchViewModel.Action(
            navigationRightButtonDidTap: navigationRightLoginButton.rx.tap.asDriver(),
            typingKeyword: searchController.searchBar.searchTextField.rx.text.map { $0 ?? "" }.asDriver(onErrorJustReturn: ""),
            searchDidTap: searchDidTap,
            cancelDidTap: searchController.searchBar.rx.cancelButtonClicked.asDriver(),
            loadNextPage: loadNextPage
        )
        
        let state = viewModel.transform(from: action)
        
        state.isHiddenLoadingView
            .asObservable()
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind { vc, isHidden in
                isHidden ? vc.loadingIndicatorView.stopAnimating() : vc.loadingIndicatorView.startAnimating()
                vc.loadingIndicatorView.isHidden = isHidden
            }
            .disposed(by: disposeBag)
        
        state.errMsg
            .asObservable()
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind { vc, errMsg in
                vc.showAlertPopup(
                    message: errMsg,
                    buttons: [UIAlertAction(title: StringLiterals.Common.ok, style: .cancel)]
                )
            }
            .disposed(by: disposeBag)
        
        state.keyword
            .asObservable()
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind { vc, keyword in
                vc.searchController.searchBar.text = keyword
            }
            .disposed(by: disposeBag)
        
        state.repositories
            .asObservable()
            .map { [RepositorySectionData(items: $0)] }
            .observe(on: MainScheduler.instance)
            .bind(to: repositoryTableView.rx.items(dataSource: repositoryDataSource))
            .disposed(by: disposeBag)
    }
}
