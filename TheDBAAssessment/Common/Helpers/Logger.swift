//
//  Logger.swift
//  TheDBAAssessment
//
//  Created by HungNguyen on 2024/03/21.
//

import Foundation

private let showLog: Bool = {
    #if DEBUG
        return true
    #else
        return false
    #endif
}()

final class Logger {
    static func log(_ message: String) {
        guard showLog else {
            return
        }
        
        print(message)
    }
}
