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
        Publishers.Concatenate(
            prefix: recipesRepository.loadLocalRecipes()
                .catch { _ -> AnyPublisher<[RecipeEntity], Error> in
                    // Ignore error from loading local recipes
                    Result.Publisher(.success([])).eraseToAnyPublisher()
                },
            suffix: recipesRepository.loadRemoteRecipes()
                .handleEvents(receiveOutput: {
                    recipesRepository.cacheRecipes(recipes: $0)
                })
        )
        .eraseToAnyPublisher()
    }
}
