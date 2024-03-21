//
//  RecipeRepositoryMock.swift
//  TheDBAAssessmentTests
//
//  Created by HungNguyen on 2024/03/21.
//

import Foundation
import Combine
@testable import TheDBAAssessment

final class RecipeRepositoryMock {
    var localRecipes: [RecipeEntity] = []
    var remoteRecipes: [RecipeEntity] = []
    var shouldLoadLocalFail = false
    var shouldLoadRemoteFail = false
    var shouldCacheFail = false
}

extension RecipeRepositoryMock: RecipeRepositoryProtocol {
    func loadLocalRecipes() -> AnyPublisher<[RecipeEntity], Error> {
        Deferred {
            Future<[RecipeEntity], Error> { future in
                if self.shouldLoadLocalFail {
                    future(.failure(MockError.forcedError))
                } else {
                    future(.success(self.localRecipes))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func loadRemoteRecipes() -> AnyPublisher<[RecipeEntity], Error> {
        Deferred {
            Future<[RecipeEntity], Error> { future in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    if self.shouldLoadRemoteFail {
                        future(.failure(MockError.forcedError))
                    } else {
                        future(.success(self.remoteRecipes))
                    }
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func cacheRecipes(recipes: [RecipeEntity]) {
        if !shouldCacheFail {
            localRecipes = recipes
        }
    }
    
    func loadLocalRecipe(by id: String) -> AnyPublisher<TheDBAAssessment.RecipeEntity?, Error> {
        fatalError("Not implemented!")

    }
}
