//
//  Endpoint.swift
//  TheDBAAssessment
//
//  Created by HungNguyen on 2024/03/21.
//

import Foundation

enum RecipeEndpoint {
    case terms
    case matches
}

extension RecipeEndpoint: EndpointConvertible {
    private var basePath: String { "/recipes" }
    
    var shouldAuthorized: Bool {
        false
    }
    
    var path: String {
        switch self {
        case .terms:
            return basePath
        case .matches:
            return "\(basePath)/matches"
        }
    }

    var httpMethod: HTTPMethod {
        switch self {
        case .terms, .matches:
            return .get
        }
    }

    var httpBody: Data? {
        nil
    }
}
