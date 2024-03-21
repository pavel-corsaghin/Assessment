//
//  CDRecipe+Mapper.swift
//  Assessment
//
//  Created by HungNguyen on 2024/03/21.
//

import Foundation
import CoreData

extension CdRecipe {
    var asEntity: RecipeEntity {
        .init(
            id: id,
            name: name,
            description: recipeDescription,
            headline: headline,
            thumb: thumb,
            difficulty: Int(difficulty),
            proteins: proteins,
            calories: calories,
            carbos: carbos,
            time: time,
            fats: fats,
            image: image
        )
    }
}

extension RecipeEntity {
    func toCoreData(context: NSManagedObjectContext, index: Int) -> CdRecipe {
        let cdEntity = CdRecipe(context: context)
        cdEntity.index = Int32(index)
        cdEntity.id = id
        cdEntity.name = name
        cdEntity.recipeDescription = description
        cdEntity.headline = headline
        cdEntity.thumb = thumb
        cdEntity.difficulty = Int32(difficulty ?? 0)
        cdEntity.proteins = proteins
        cdEntity.calories = calories
        cdEntity.carbos = carbos
        cdEntity.fats = fats
        cdEntity.time = time
        cdEntity.image = image
        return cdEntity
    }
}
