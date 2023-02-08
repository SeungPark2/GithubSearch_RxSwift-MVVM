//
//  BaseTabBarController.swift
//  GithubSearch_MVVM+RxSwift
//
//  Created by 박승태 on 2023/02/08.
//

import UIKit

class BaseTabBarController: UITabBarController {
    
    // MARK: -- Properties
    
    var searchNavigationController = UINavigationController()
    var profileNavigationController = UINavigationController()
    
    // MARK: -- Initalize
    
    init(user: User) {
        super.init(nibName: nil, bundle: nil)
        
        setUpTabBars(with: user)
        setUpTabBarColors()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -- Life Cycle
    
    // MARK: -- Methods
    
    private func setUpTabBars(with user: User) {
        let githubSearchRepository = GithubSearchRepository()
        let githubUseCase = GithubSearchUseCase(repository: githubSearchRepository, user: user)
        let githubViewModel = GithubSearchViewModel(useCase: githubUseCase)
        let githubViewController = GithubSearchViewController(viewModel: githubViewModel)
        searchNavigationController = UINavigationController(rootViewController: githubViewController)
        searchNavigationController.navigationBar.backgroundColor = Color.DarkGray.RGB64
        searchNavigationController.tabBarItem = UITabBarItem(
            title: "Search",
            image: UIImage(systemName: "magnifyingglass"),
            tag: 0
        )
        let profileRepository = ProfileRepository()
        let profileUseCase = ProfileUseCase(repository: profileRepository, user: user)
        let profileViewModel = ProfileViewModel(useCase: profileUseCase)
        let profileViewController = ProfileViewController(viewModel: profileViewModel)
        profileNavigationController = UINavigationController(rootViewController: profileViewController)
        profileNavigationController.navigationBar.backgroundColor = Color.DarkGray.RGB64
        profileNavigationController.tabBarItem = UITabBarItem(
            title: "Profile",
            image: UIImage(systemName: "person.fill"),
            tag: 1
        )
        setViewControllers([searchNavigationController, profileNavigationController], animated: false)
    }
    
    private func setUpTabBarColors() {
        tabBar.backgroundColor = Color.DarkGray.RGB64
        tabBar.tintColor = .black
        tabBar.unselectedItemTintColor = .lightGray
    }
    
    // MARK: -- AddViews
    
    // MARK: -- SetUpViewsLayout
    
    // MARK: -- UI
}
