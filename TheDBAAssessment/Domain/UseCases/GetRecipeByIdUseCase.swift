//
//  GetRecipeByIdUseCase.swift
//  TheDBAAssessment
//
//  Created by HungNguyen on 2024/03/21.
//

import Foundation
import Combine

protocol GetRecipeByIdUseCaseProtocol {
    func execute(id: String) -> AnyPublisher<RecipeEntity?, Error>
}

struct GetRecipeByIdUseCase: GetRecipeByIdUseCaseProtocol {
    let recipesRepository: RecipeRepositoryProtocol

    init(recipesRepository: RecipeRepositoryProtocol) {
        self.recipesRepository = recipesRepository
    }

    func execute(id: String) -> AnyPublisher<RecipeEntity?, Error> {
        recipesRepository.loadLocalRecipe(by: id)
    }
}
