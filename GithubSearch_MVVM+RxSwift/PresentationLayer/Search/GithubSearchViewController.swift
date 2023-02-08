//
//  GithubSearchViewController.swift
//  GithubSearch_MVVM+RxSwift
//
//  Created by 박승태 on 2023/02/07.
//

import UIKit

import SnapKit
import Then
import RxSwift

class GithubSearchViewController: UIViewController {
    
    // MARK: -- Properties
    
    private let viewModel: GithubSearchViewModel
    private let disposeBag = DisposeBag()
    
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
    }
    
    // MARK: -- Methods
    
    private func updateNavigationTiTle() {
        navigationItem.title = "search"
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
        
        view.layoutIfNeeded()
    }
    
    // MARK: -- UI
    
    private let navigationRightLoginButton = UIBarButtonItem().then {
        $0.image = Image.LoginLogout.login
        $0.tintColor = .white
    }
    
    private let searchController = UISearchController(searchResultsController: nil).then {
        $0.searchBar.placeholder = "검색어 입력"
        $0.searchBar.setValue("취소", forKey: "cancelButtonText")
        $0.searchBar.tintColor = .black
        $0.searchBar.searchTextField.leftView?.tintColor = .lightGray
        $0.searchBar.searchTextField.textColor = .black
        $0.searchBar.searchTextField.accessibilityIdentifier = "searchBarTextField"
    }
    
    private let repositoryTableView = UITableView().then {
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 100
        $0.register(RepositoryTableViewCell.self, forCellReuseIdentifier: RepositoryTableViewCell.identifier)
    }
    
    private let loadingIndicatorView = UIActivityIndicatorView().then {
        $0.style = .large
        $0.tintColor = .white
    }
}
