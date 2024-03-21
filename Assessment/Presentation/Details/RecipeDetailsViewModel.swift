//
//  RecipeDetailsViewModel.swift
//  Assessment
//
//  Created by HungNguyen on 2024/03/21.
//

import Foundation
import Combine

final class RecipeDetailsViewModel: BaseViewModel {
    
    // MARK: - Properties
    
    private let getRecipeByIdUseCase: GetRecipeByIdUseCaseProtocol
    private let recipeId: String
    @Published private(set) var recipe: RecipeEntity?
    
    // MARK: - Initializer
    
    init(getRecipeByIdUseCase: GetRecipeByIdUseCaseProtocol, recipeId: String) {
        self.getRecipeByIdUseCase = getRecipeByIdUseCase
        self.recipeId = recipeId
    }

    // MARK: - Actions
    
    func getRecipeDetails() {
        isLoading = true
        getRecipeByIdUseCase.execute(id: recipeId)
            .sink(
                receiveCompletion: { [weak self] completion in
                    guard let self else { return }
                    if case .failure(let error) = completion {
                        self.error = error
                    }
                    isLoading = false
                },
                receiveValue: { [weak self] recipe in
                    self?.recipe = recipe
                }
            )
            .store(in: &cancellables)
    }
}
