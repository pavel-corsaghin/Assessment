//
//  RecipeCellModel.swift
//  TheDBAAssessment
//
//  Created by HungNguyen on 2024/03/21.
//

import Foundation

struct RecipeCellModel: Hashable {
    let id: String?
    let name: String?
    let difficulty: String?
    let headline: String?
    let thumb: String?
    
    init(_ entity: RecipeEntity) {
        id = entity.id
        name = entity.name
        headline = entity.headline
        difficulty = "Difficulty: \(entity.difficulty ?? 0)"
        thumb = entity.thumb
    }
}
