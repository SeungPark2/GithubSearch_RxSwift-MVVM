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
        
    }
    
    // MARK: -- Methods
    
    // MARK: -- AddViews
    
    // MARK: -- SetUpViewsLayout
    
    // MARK: -- UI
    
}
