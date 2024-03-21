//
//  RecipeDetailsViewController.swift
//  Assessment
//
//  Created by HungNguyen on 2024/03/21.
//

import UIKit
import Combine

final class RecipeDetailsViewController: BaseViewController {
    
    // MARK: - Properties
    
    private let viewModel: RecipeDetailsViewModel
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.backward")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .black
        button.backgroundColor = .white
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
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
        label.font = .boldSystemFont(ofSize: 22)
        label.setContentHuggingPriority(.required, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 18)
        label.setContentHuggingPriority(.required, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .black
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    private let infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = .init(top: 16, left: 16, bottom: 0, right: 16)
        return stackView
    }()
    
    private let firstDetailsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        return stackView
    }()
    
    private let secondDetailsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        return stackView
    }()
    
    private let contenStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: - Initializer
    
    init(viewModel: RecipeDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupBindings()
        viewModel.getRecipeDetails()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    // MARK: - Setups
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(contenStackView)
        view.addSubview(backButton)
        contenStackView.addArrangedSubview(thumbImageView)
        contenStackView.addArrangedSubview(infoStackView)
        infoStackView.addArrangedSubview(titleLabel)
        infoStackView.addArrangedSubview(subtitleLabel)
        infoStackView.addArrangedSubview(firstDetailsStackView)
        infoStackView.addArrangedSubview(secondDetailsStackView)
        infoStackView.addArrangedSubview(descriptionLabel)
        infoStackView.addArrangedSubview(UIView())
    }
    
    private func setupConstraints() {
        backButton.sizeTo(40)
        contenStackView.pinHorizontalEdgesToSupperView()
        NSLayoutConstraint.activate([
            contenStackView.topAnchor.constraint(equalTo: view.topAnchor),
            contenStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            thumbImageView.heightAnchor.constraint(equalTo: thumbImageView.widthAnchor, multiplier: 212.0 / 300.0),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -8),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
        infoStackView.setCustomSpacing(24, after: subtitleLabel)
        infoStackView.setCustomSpacing(24, after: secondDetailsStackView)
    }
    
    private func setupBindings() {
        viewModel.$recipe
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.bindRecipeDetails($0)
            }
            .store(in: &cancellables)
        
        backButton.tapPublisher
            .sink { [unowned self] in
                navigationController?.popViewController(animated: true)
            }
            .store(in: &cancellables)
    }
    
    private func bindRecipeDetails(_ recipe: RecipeEntity) {
        titleLabel.text = recipe.name
        subtitleLabel.text = recipe.headline
        descriptionLabel.text = recipe.description
        firstDetailsStackView.addArrangedSubview(
            makeDetailsItem(title: "Difficulty", value: "\(recipe.difficulty ?? 0)")
        )
        firstDetailsStackView.addArrangedSubview(
            makeDetailsItem(title: "Calories", value: recipe.calories)
        )
        firstDetailsStackView.addArrangedSubview(
            makeDetailsItem(title: "Time", value: recipe.time)
        )
        secondDetailsStackView.addArrangedSubview(
            makeDetailsItem(title: "Proteins", value: recipe.proteins)
        )
        secondDetailsStackView.addArrangedSubview(
            makeDetailsItem(title: "Fats", value: recipe.fats)
        )
        secondDetailsStackView.addArrangedSubview(
            makeDetailsItem(title: "Carbos", value: recipe.carbos)
        )
        ImageLoader.shared.loadImage(from: recipe.image)
            .sink { [weak self] image in
                self?.thumbImageView.image = image
            }
            .store(in: &cancellables)
    }
    
    private func makeDetailsItem(title: String, value: String?) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 4
        stackView.backgroundColor = .black.withAlphaComponent(0.08)
        stackView.layer.cornerRadius = 4
        stackView.layer.masksToBounds = true
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = .init(top: 8, left: 0, bottom: 8, right: 0)
        let titleLabel = UILabel()
        titleLabel.textColor = .black
        titleLabel.font = .boldSystemFont(ofSize: 16)
        titleLabel.text = title
        let valueLabel = UILabel()
        valueLabel.textColor = .darkGray
        valueLabel.font = .systemFont(ofSize: 18)
        valueLabel.text = value
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(valueLabel)
        return stackView
    }
}
