//
//  Recipe.swift
//  TheDBAAssessment
//
//  Created by HungNguyen on 2024/03/21.
//

import Foundation

struct Recipe: Decodable {
    let id: String?
    let name: String?
    let description: String?
    let headline: String?
    let thumb: String?
    let difficulty: Int?
    let proteins: String?
    let calories: String?
    let carbos: String?
    let time: String?
    let fats: String?
    let image: String?
}

extension Recipe {
    var asEntity: RecipeEntity {
        .init(
            id: id,
            name: name,
            description: description,
            headline: headline,
            thumb: thumb,
            difficulty: difficulty,
            proteins: proteins,
            calories: calories,
            carbos: carbos,
            time: time,
            fats: fats,
            image: image
        )
    }
}
