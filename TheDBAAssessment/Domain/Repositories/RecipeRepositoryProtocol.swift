//
//  RecipeRepositoryProtocol.swift
//  TheDBAAssessment
//
//  Created by HungNguyen on 2024/03/21.
//

import Foundation
import Combine

protocol RecipeRepositoryProtocol {
    func fetchRecipes() -> AnyPublisher<[RecipeEntity], Error>
    func fetchRecipe(by id: String) -> AnyPublisher<RecipeEntity?, Error>
}
