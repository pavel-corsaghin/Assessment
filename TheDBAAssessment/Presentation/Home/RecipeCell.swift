//
//  RecipeCell.swift
//  TheDBAAssessment
//
//  Created by HungNguyen on 2024/03/21.
//

import UIKit

final class RecipeCell: BaseCollectionCell {
    
    // MARK: - UI Properties
    
    private let thumbImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 16)
        label.setContentHuggingPriority(.required, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textColor = .black
        label.font = .systemFont(ofSize: 14)
        label.setContentHuggingPriority(.required, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()
    
    private let difficultyLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private let infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()
    
    private let contenStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.layer.cornerRadius = 8
        stackView.layer.masksToBounds = true
        stackView.backgroundColor = .black.withAlphaComponent(0.08)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = .init(top: 0, left: 8, bottom: 0, right: 8)
        return stackView
    }()
    
    // MARK: - Setups
    
    override func setupViews() {
        contentView.addSubview(contenStackView)
        contenStackView.addArrangedSubview(thumbImageView)
        contenStackView.addArrangedSubview(infoStackView)
        infoStackView.addArrangedSubview(titleLabel)
        infoStackView.addArrangedSubview(subtitleLabel)
        infoStackView.addArrangedSubview(difficultyLabel)
    }
    
    override func setupConstraints() {
        contenStackView.pinEdgesToSupperView()
        infoStackView.pinVerticalEdgesToSupperView(inset: 8)
        thumbImageView.sizeTo(width: 150, height: 106)
    }
}

// MARK: - Data binding

extension RecipeCell {
    func configureCell(with cellModel: RecipeCellModel) {
        titleLabel.text = cellModel.name
        subtitleLabel.text = cellModel.headline
        difficultyLabel.text = cellModel.difficulty
        ImageLoader.shared.loadImage(from: cellModel.thumb)
            .sink { [weak self] image in
                self?.thumbImageView.image = image
            }
            .store(in: &cancellables)
    }
}
