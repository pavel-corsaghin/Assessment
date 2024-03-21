//
//  ImageLoader.swift
//  Assessment
//
//  Created by HungNguyen on 2024/03/21.
//

import UIKit
import Combine

final class ImageLoader {
    
    static let shared = ImageLoader()
    private init() {
        cache = ImageCache()
    }

    private let cache: ImageCacheProtocol
    
    func loadImage(from url: String?) -> AnyPublisher<UIImage?, Never> {
        guard let url, let _url = URL(string: url) else {
            return Just(nil).eraseToAnyPublisher()
        }
        
        return loadImage(from: _url)
    }

    func loadImage(from url: URL?) -> AnyPublisher<UIImage?, Never> {
        guard let url else {
            return Just(nil).eraseToAnyPublisher()
        }
        if let image = cache[url] {
            return Just(image).eraseToAnyPublisher()
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { data, response -> UIImage? in return UIImage(data: data) }
            .catch { error in return Just(nil) }
            .handleEvents(receiveOutput: {[unowned self] image in
                guard let image = image else { return }
                cache[url] = image
            })
            .subscribe(on: DispatchQueue.global(qos: .userInitiated))
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
