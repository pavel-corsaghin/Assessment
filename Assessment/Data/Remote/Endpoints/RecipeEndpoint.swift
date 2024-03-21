//
//  Endpoint.swift
//  Assessment
//
//  Created by HungNguyen on 2024/03/21.
//

import Foundation

enum RecipeEndpoint {
    case recipes
}

extension RecipeEndpoint: EndpointConvertible {
    private var basePath: String { "/android-test" }
    
    var shouldAuthorized: Bool {
        false
    }
    
    var path: String {
        switch self {
        case .recipes:
            return "\(basePath)/recipes.json"
        }
    }

    var httpMethod: HTTPMethod {
        switch self {
        case .recipes:
            return .get
        }
    }

    var httpBody: Data? {
        nil
    }
}
