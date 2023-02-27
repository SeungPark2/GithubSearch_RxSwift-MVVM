//
//  ProfileViewController.swift
//  GithubSearch_MVVM+RxSwift
//
//  Created by 박승태 on 2023/02/08.
//

import UIKit

import SnapKit
import Then
import RxCocoa
import RxDataSources
import RxSwift

final class ProfileViewController: UIViewController {
    
    // MARK: -- Properties
    
    private let viewModel: ProfileViewModel
    private let disposeBag = DisposeBag()
    private var refresh = PublishRelay<Void>()
    private var logInSuccess = PublishRelay<String>()
    private var starButtonDidTap = PublishRelay<Int>()
    private let repositoryDataSource = RxTableViewSectionedReloadDataSource<RepositorySectionData> { dataSource, tableView, indexPath, repository in
        RepositoryTableViewCell.confiure(tableView: tableView, indexPath: indexPath, repository: repository)
    }
    
    // MARK: -- Initalize
    
    init(viewModel: ProfileViewModel) {
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
    }
    
    // MARK: -- Methods
    
    private func updateNavigationTiTle() {
        navigationItem.title = Literals.Title.profile
    }
    
    private func setUpNavigationBarAndTabBar() {
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationItem.hidesSearchBarWhenScrolling = false
        tabBarController?.tabBar.isTranslucent = true
        tabBarController?.tabBar.backgroundImage = UIImage()
        tabBarController?.tabBar.shadowImage = UIImage()
    }
    
    @objc
    private func refreshing() {
        refresh.accept(Void())
    }
    
    // MARK: -- AddViews
    
    private func addViews() {
        navigationController?.navigationItem.rightBarButtonItem = navigationRightLoginButton
        loginView.addSubViews(loginGuideLabel, loginButton)
        view.addSubViews(loginView, repositoryTableView, loadingIndicatorView)
    }
    
    // MARK: -- SetUpViewsLayout
    
    private func setUpViewsLayout() {
        loginView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        loginGuideLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().inset(-5)
        }
        
        loginButton.snp.makeConstraints {
            $0.top.equalTo(loginGuideLabel.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
        
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
    
    private let loginView = UIView()
    
    private let loginGuideLabel = UILabel().then {
        $0.text = "관심 등록한 저장소를 보려면 로그인을 해주세요."
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 16, weight: .medium)
    }
    
    private let loginButton = UIButton().then {
        $0.setTitle("로그인", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 14)
        $0.backgroundColor = Color.Gray.RGB173
    }
    
    private lazy var repositoryTableView = UITableView().then {
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 180
        $0.separatorInset = .init(top: 0, left: 10, bottom: 0, right: 20)
        $0.register(RepositoryTableViewCell.self, forCellReuseIdentifier: RepositoryTableViewCell.identifier)
    }
    
    private lazy var refreshControl = UIRefreshControl().then {
        $0.addTarget(self, action: #selector(refreshing), for: .valueChanged)
    }
    
    private let loadingIndicatorView = UIActivityIndicatorView().then {
        $0.style = .large
        $0.tintColor = .white
    }
}

extension ProfileViewController {
    
    private func bindViewModel() {
        let prefetchRows = repositoryTableView.rx.prefetchRows
            .compactMap(\.last?.row)
            .filter { row in
                (row + 1) % 10 == 0
            }
        
        let lastIndexCheck = repositoryTableView.rx.contentOffset
            .filter { [weak self] offset in
                guard let `self` = self else { return false }
                guard self.repositoryTableView.frame.height > 0 else { return false }
                return offset.y + self.repositoryTableView.frame.height >= self.repositoryTableView.contentSize.height + 30
            }
        
        let loadNextPage = Observable.combineLatest(prefetchRows, lastIndexCheck)
            .map { _, _ in }.asDriver(onErrorJustReturn: ())
        
        let action = ProfileViewModel.Action(
            navigationRightButtonDidTap: navigationRightLoginButton.rx.tap.asDriver(),
            logInSuccess: logInSuccess.asDriver(onErrorJustReturn: ""),
            refresh: refresh.asDriver(onErrorJustReturn: ()),
            loadNextPage: loadNextPage,
            starButtonDidTap: starButtonDidTap.asDriver(onErrorJustReturn: -1)
        )
        
        let state = viewModel.transform(from: action)
        
        state.isHiddenLoadingView
            .asObservable()
            .observe(on: MainScheduler.instance)
            .bind { [weak self] isHidden in
                isHidden ? self?.loadingIndicatorView.stopAnimating() : self?.loadingIndicatorView.startAnimating()
                self?.loadingIndicatorView.isHidden = isHidden
            }
            .disposed(by: disposeBag)
        
        state.errMsg
            .asObservable()
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind { vc, errMsg in
                vc.showAlertPopup(
                    message: errMsg,
                    buttons: [UIAlertAction(title: Literals.Common.ok, style: .cancel)]
                )
            }
            .disposed(by: disposeBag)
        
        state.userInfo
            .filter { $0.name.isEmpty }
            .asObservable()
            .observe(on: MainScheduler.instance)
            .bind { [weak self] userInfo in
                
            }
            .disposed(by: disposeBag)
        
        state.starRepositories
            .asObservable()
            .map { [RepositorySectionData(items: $0)] }
            .observe(on: MainScheduler.instance)
            .bind(to: repositoryTableView.rx.items(dataSource: repositoryDataSource))
            .disposed(by: disposeBag)
    }
}
