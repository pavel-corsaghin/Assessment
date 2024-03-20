//
//  GetRecipesUseCase.swift
//  TheDBAAssessment
//
//  Created by HungNguyen on 2024/03/21.
//

import Foundation
import Combine

protocol GetRecipesUseCaseProtocol {
    func execute() -> AnyPublisher<[RecipeEntity], Error>
}

struct GetRecipesUseCase: GetRecipesUseCaseProtocol {
    let recipesRepository: RecipeRepositoryProtocol

    init(recipesRepository: RecipeRepositoryProtocol) {
        self.recipesRepository = recipesRepository
    }

    func execute() -> AnyPublisher<[RecipeEntity], Error> {
        recipesRepository.fetchRecipes()
    }

}
