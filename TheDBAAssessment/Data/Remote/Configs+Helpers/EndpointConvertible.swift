//
//  EndpointConvertible.swift
//  TheDBAAssessment
//
//  Created by HungNguyen on 2024/03/21.
//

import Foundation

typealias HTTPHeaders = [String: String]

protocol EndpointConvertible {
    
    /// Determines whenever the request should be authorized
    var shouldAuthorized: Bool { get }
    
    /// The path of the endpoint
    var path: String { get }

    /// The HTTP method of the endpoint
    var httpMethod: HTTPMethod { get }

    /// The HTTP Body of the endpoint
    var httpBody: Data? { get }

    /// The headers of the endpoint
    var headers: HTTPHeaders { get }

    /// The query params of the endpoint
    var queryItems: [String: Any]? { get }
}

extension EndpointConvertible {
    var defaultHeaders: HTTPHeaders {
        [
            "Accept" : "application/json",
            "Content-Type" : "application/json"
        ]
    }
    var headers: HTTPHeaders {
        [:]
    }

    var queryItems: [String : Any]? {
        nil
    }
}

extension EndpointConvertible {
    
    var request: URLRequest? {
        guard let url = URL(string: environment.baseURL),
              var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        else {
            return nil
        }
        
        // queryItems
        components.path = path
        if let queryItems = queryItems?.compactMap({ URLQueryItem(name: $0.key, value: "\($0.value)") }) {
            components.queryItems = queryItems
        }
        guard let compUrl = components.url else {
            return nil
        }
        var request = URLRequest(url: compUrl)
        
        // headers
        defaultHeaders.forEach { (key: String, value: String) in
            request.setValue(value, forHTTPHeaderField: key)
        }
        headers.forEach { (key: String, value: String) in
            request.setValue(value, forHTTPHeaderField: key)
        }
        if shouldAuthorized {
            let token = "" // TODO: Get token from caching storage
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        // method
        request.httpMethod = httpMethod.rawValue
        
        // body
        request.httpBody = httpBody
        
        return request
    }
}
