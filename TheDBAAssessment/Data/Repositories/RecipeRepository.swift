//
//  RecipeRepository.swift
//  TheDBAAssessment
//
//  Created by HungNguyen on 2024/03/21.
//

import Foundation
import Combine

struct RecipeRepository: RecipeRepositoryProtocol {
    func fetchRecipes() -> AnyPublisher<[RecipeEntity], Error> {
        Network<[Recipe]>().request(RecipeEndpoint.matches)
            .map { $0.map { $0.asEntity } }
            .eraseToAnyPublisher()
    }
}
