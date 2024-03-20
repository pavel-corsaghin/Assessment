//
//  HomeCoordinator.swift
//  TheDBAAssessment
//
//  Created by HungNguyen on 2024/03/21.
//

import UIKit

final class HomeCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init() {
        navigationController = UINavigationController()
    }
    
    func start() {
        let viewModel = HomeViewModel.make()
        let viewController = HomeViewController.make(viewModel: viewModel)
        navigationController.viewControllers = [viewController]
    }
}
