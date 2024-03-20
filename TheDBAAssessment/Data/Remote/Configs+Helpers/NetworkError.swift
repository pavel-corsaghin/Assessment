//
//  NetworkError.swift
//  TheDBAAssessment
//
//  Created by HungNguyen on 2024/03/21.
//

import Foundation

enum NetworkError: Error, Equatable {
    case custom(_ message: String?,_ statusCode: HttpStatus?)
    case invalidRequest
    case invalidResponse
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case let .custom(message, statusCode):
            return message ?? statusCode?.description
        case .invalidRequest:
            return "Invalid request"
        case .invalidResponse:
            return "Invalid response"
        }
    }
}
