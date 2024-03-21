//
//  BaseCollectionCell.swift
//  Assessment
//
//  Created by HungNguyen on 2024/03/21.
//

import UIKit
import Combine

class BaseCollectionCell: UICollectionViewCell {
    var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cancellables.removeAll()
        setupBindings()
    }
    
    func commonInit() {
        setupViews()
        setupConstraints()
        setupBindings()
    }
    
    // MARK: - Setups
    
    func setupViews() {}
    
    func setupConstraints() {}
    
    func setupBindings() {}
}
