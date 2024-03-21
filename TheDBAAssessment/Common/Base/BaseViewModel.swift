//
//  BaseViewModel.swift
//  TheDBAAssessment
//
//  Created by HungNguyen on 2024/03/21.
//

import Foundation
import Combine

class BaseViewModel {

    @Published var isLoading = false
    @Published var error: Error?

    var cancellables = Set<AnyCancellable>()

    deinit {
        cancellables.removeAll()

        #if DEBUG
        print(String(describing: Self.self), "is deallocated")
        #endif
    }

}
