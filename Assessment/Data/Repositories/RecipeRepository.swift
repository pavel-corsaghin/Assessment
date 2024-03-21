//
//  RecipeRepository.swift
//  Assessment
//
//  Created by HungNguyen on 2024/03/21.
//

import Foundation
import Combine
import CoreData

struct RecipeRepository: RecipeRepositoryProtocol {
    private let network = Network<[Recipe]>()
    private let storage = StorageCRUD<CdRecipe>()

    func loadLocalRecipe(by id: String) -> AnyPublisher<RecipeEntity?, Error> {
        let context = storage.context
        return Deferred { [context] in
            Future { promise in
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CdRecipe.entity().name!)
                let predicate = NSPredicate(format: "id = %@", argumentArray: [id])
                fetchRequest.predicate = predicate
                do {
                    let result = try context.fetch(fetchRequest)
                    guard let cdRecipe = (result as? [CdRecipe])?.first else {
                        promise(.success(nil))
                        return
                    }
                    promise(.success(cdRecipe.asEntity))
                } catch {
                    promise(.failure(CoreDataStorageError.readError(error)))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func loadLocalRecipes() -> AnyPublisher<[RecipeEntity], Error> {
        storage.fetchAllEntities()
            .map { $0.sorted{ $0.index < $1.index }.compactMap { $0.asEntity } }
            .eraseToAnyPublisher()
    }
    
    func loadRemoteRecipes() -> AnyPublisher<[RecipeEntity], Error> {
        network.request(RecipeEndpoint.recipes)
            .map { $0.map { $0.asEntity } }
            .eraseToAnyPublisher()
    }
    
    func cacheRecipes(recipes: [RecipeEntity]) {
        storage.deleteAllEntities()
        let entities = recipes.enumerated().map { index, recipe in
            recipe.toCoreData(context: storage.context, index: index)
        }
        storage.cacheEntities(entities: entities)
    }
}
