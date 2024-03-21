//
//  BaseViewController.swift
//  TheDBAAssessment
//
//  Created by HungNguyen on 2024/03/21.
//

import UIKit
import Combine

class BaseViewController: UIViewController {
    lazy var loadingIndicator: UIActivityIndicatorView = {
        let loadingIndicator = UIActivityIndicatorView()
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadingIndicator)
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        return loadingIndicator
    }()
    var cancellables = Set<AnyCancellable>()

    deinit {
        cancellables.removeAll()

        #if DEBUG
        print(String(describing: Self.self), "is deallocated")
        #endif
    }
}

// MARK: - Reusable bindings

extension BaseViewController {
  func bindLoadingPublisher(_ publisher: AnyPublisher<Bool, Never>) {
    publisher
      .removeDuplicates()
      .receive(on: DispatchQueue.main)
      .sink { [weak self] isLoading in
        guard let self else { return }
        if isLoading {
          loadingIndicator.startAnimating()
        } else {
          loadingIndicator.stopAnimating()
        }
        view.isUserInteractionEnabled = !isLoading
      }
      .store(in: &cancellables)
  }
  func bindErrorPublisher(_ publisher: AnyPublisher<Error, Never>) {
    publisher
      .receive(on: DispatchQueue.main)
      .sink { [weak self] in
          self?.showSimpleAlert("Error", $0.localizedDescription)
      }
      .store(in: &cancellables)
  }
}

// MARK: - Reusable methods

extension BaseViewController {
    func showSimpleAlert(_ title: String,_ message: String) {
        let alertController = UIAlertController(
          title: title,
          message: message,
          preferredStyle: .alert
        )
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
}
