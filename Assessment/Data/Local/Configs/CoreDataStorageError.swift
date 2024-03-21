//
//  CoreDataStorageError.swift
//  Assessment
//
//  Created by HungNguyen on 2024/03/21.
//

import Foundation

enum CoreDataStorageError: Error {
    case readError(Error)
    case saveError(Error)
    case deleteError(Error)
}
