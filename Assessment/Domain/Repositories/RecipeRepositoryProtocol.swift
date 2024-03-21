//
//  RecipeRepositoryProtocol.swift
//  Assessment
//
//  Created by HungNguyen on 2024/03/21.
//

import Foundation
import Combine

protocol RecipeRepositoryProtocol {
    func loadLocalRecipes() -> AnyPublisher<[RecipeEntity], Error>
    func loadRemoteRecipes() -> AnyPublisher<[RecipeEntity], Error>
    func cacheRecipes(recipes: [RecipeEntity])
    func loadLocalRecipe(by id: String) -> AnyPublisher<RecipeEntity?, Error>
}
