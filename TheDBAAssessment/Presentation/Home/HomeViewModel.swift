//
//  HomeViewModel.swift
//  TheDBAAssessment
//
//  Created by HungNguyen on 2024/03/21.
//

import Foundation
import Combine

final class HomeViewModel: BaseViewModel {
    
    // MARK: - Coordinator
    
    var onOpenRecipeDetails: ((String) -> Void)?
    
    // MARK: - Properties
    
    private let getRecipesUseCase: GetRecipesUseCaseProtocol
    @Published private(set) var recipes: [RecipeEntity] = []

    // MARK: - Initializer
    
    init(getRecipesUseCase: GetRecipesUseCaseProtocol) {
        self.getRecipesUseCase = getRecipesUseCase
    }
    
    // MARK: - Actions
    
    func getRecipes() {
        isLoading = true
        getRecipesUseCase.execute()
            .sink(
                receiveCompletion: { [weak self] completion in
                    guard let self else { return }
                    if case .failure(let error) = completion {
                        self.error = error
                    }
                    isLoading = false
                },
                receiveValue: { [weak self] recipes in
                    self?.recipes = recipes
                }
            )
            .store(in: &cancellables)
    }
}
