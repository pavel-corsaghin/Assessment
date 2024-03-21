//
//  Environment.swift
//  Assessment
//
//  Created by HungNguyen on 2024/03/21.
//

import Foundation

let environment: Environment = .dev

enum Environment {
    case dev
    case prod
}

extension Environment {
    
    var baseURL: String {
        switch self {
        case .dev:
            return "https://hf-android-app.s3-eu-west-1.amazonaws.com/"
        case .prod:
            fatalError("Not provided yet")
        }
    }
}
