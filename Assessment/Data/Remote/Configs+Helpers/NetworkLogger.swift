//
//  NetworkLogger.swift
//  Assessment
//
//  Created by HungNguyen on 2024/03/21.
//

import Foundation

final class NetworkLogger {
    
    static func log(request: URLRequest, logCURL: Bool = true) {
        Logger.log("\n - - - - - - - - - - OUTGOING - - - - - - - - - - \n")
        defer { Logger.log("\n - - - - - - - - - -  END - - - - - - - - - - \n") }

        let urlAsString = request.url?.absoluteString ?? ""
        let urlComponents = NSURLComponents(string: urlAsString)

        let method = request.httpMethod != nil ? "\(request.httpMethod ?? "")" : ""
        let path = "\(urlComponents?.path ?? "")"
        let query = "\(urlComponents?.query ?? "")"
        let host = "\(urlComponents?.host ?? "")"

        var logOutput = """
                        \(urlAsString) \n\n
                        \(method) \(path)?\(query) HTTP/1.1 \n
                        HOST: \(host)\n
                        """
        for (key,value) in request.allHTTPHeaderFields ?? [:] {
            logOutput += "\(key): \(value) \n"
        }
        if let body = request.httpBody {
            logOutput += "\n\(body.prettyPrintedJSONString ?? "")"
        }

        Logger.log(logOutput)
        
        if logCURL {
            Logger.log("=== CURL ===\n\(request.curlString)")
        }
    }

    static func log(data: Data?, response: URLResponse?, error: Error?) {
        Logger.log("\n - - - - - - - - - - INCOMING - - - - - - - - - - \n")
        defer { Logger.log("\n - - - - - - - - - - END - - - - - - - - - - \n") }

        var logOutput = ""

        if let error = error {
            logOutput += "ERROR: \(error)\n"
        }

        if let response = response as? HTTPURLResponse {
            logOutput += "RESPONSE STATUS CODE: \(response.statusCode)\n"
            logOutput += "RESPONSE HEADERS:\n"

            for (key, value) in response.allHeaderFields {
                logOutput += "\(key): \(value) \n"
            }

            logOutput += "\n"
        }

        if let data = data?.prettyPrintedJSONString {
            logOutput += "DATA: \(data)"
        }

        Logger.log(logOutput)
    }

    static func log(request: URLRequest, data: Data?, response: URLResponse?, error: Error?) {
        Logger.log("\n - - - - - - - - - - INCOMING - - - - - - - - - - \n")
        defer { Logger.log("\n - - - - - - - - - - END - - - - - - - - - - \n") }

        var logOutput = ""

        if let error = error {
            logOutput += "ERROR: \(error)\n"
        }

        if let response = response as? HTTPURLResponse {
            logOutput += "REQUEST: \(response.url?.absoluteString ?? "")\n"
            logOutput += "RESPONSE STATUS CODE: \(response.statusCode)\n"
            logOutput += "RESPONSE HEADERS:\n"

            for (key, value) in response.allHeaderFields {
                logOutput += "\(key): \(value) \n"
            }

            logOutput += "\n"
        }

        if let data = data {
            logOutput += "DATA: \(data.prettyPrintedJSONString ?? "")"
        }

        Logger.log(logOutput)
    }
}
