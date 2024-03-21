//
//  Coordinator.swift
//  Assessment
//
//  Created by HungNguyen on 2024/03/21.
//

import UIKit

protocol Coordinator {
  var navigationController: UINavigationController { get set }
  func start()
}
