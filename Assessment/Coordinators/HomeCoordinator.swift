//
//  HomeCoordinator.swift
//  Assessment
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
        let recipeRepository = RecipeRepository()
        let getRecipesUseCase = GetRecipesUseCase(recipesRepository: recipeRepository)
        let viewModel = HomeViewModel(getRecipesUseCase: getRecipesUseCase)
        viewModel.onOpenRecipeDetails = { [weak self] in
            self?.showRecipeDetails(id: $0)
        }
        let viewController = HomeViewController(viewModel: viewModel)
        navigationController.viewControllers = [viewController]
    }

    private func showRecipeDetails(id: String) {
        let recipeRepository = RecipeRepository()
        let getRecipeByIdUseCase = GetRecipeByIdUseCase(recipesRepository: recipeRepository)
        let viewModel = RecipeDetailsViewModel(getRecipeByIdUseCase: getRecipeByIdUseCase, recipeId: id)
        let viewController = RecipeDetailsViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
}
