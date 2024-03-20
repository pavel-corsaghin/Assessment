//
//  HomeViewController.swift
//  TheDBAAssessment
//
//  Created by HungNguyen on 2024/03/21.
//

import UIKit
import Combine

final class HomeViewController: UIViewController {
    private let viewModel: HomeViewModel
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    // MARK: - Setups
    
    private func setupViews() {
        view.backgroundColor = .white
    }
}

// MARK: - Factory

extension HomeViewController {
    static func make(viewModel: HomeViewModel) -> Self {
        .init(viewModel: viewModel)
    }
}
