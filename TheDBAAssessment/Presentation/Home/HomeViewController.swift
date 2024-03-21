//
//  HomeViewController.swift
//  TheDBAAssessment
//
//  Created by HungNguyen on 2024/03/21.
//

import UIKit
import Combine

final class HomeViewController: BaseViewController {
    
    // MARK: - Properties
    
    private let viewModel: HomeViewModel
    private lazy var dataSource = makeDataSource()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeCollectionViewLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.register(cellWithClass: RecipeCell.self)
        return collectionView
    }()
    
    // MARK: - Initializer
    
    init(viewModel: HomeViewModel) {
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
        viewModel.getRecipes()
    }
    
    // MARK: - Setups
    
    private func setupViews() {
        navigationItem.title = "Recipes"
        view.backgroundColor = .white
        view.addSubview(collectionView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func setupBindings() {
        bindLoadingPublisher(viewModel.$isLoading.eraseToAnyPublisher())
        bindErrorPublisher(viewModel.$error.compactMap { $0 }.eraseToAnyPublisher())
        
        viewModel.$recipes
            .compactMap { [weak self] in
                self?.generateDataSnapshot($0)
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] snapShot in
                self?.dataSource.apply(snapShot)
            }
            .store(in: &cancellables)
    }
    
    private func generateDataSnapshot(_ recipes: [RecipeEntity]) -> Snapshot {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(recipes.map(RecipeCellModel.init))
        return snapshot
    }
}

// MARK: - CollectionView Layout + DataSource

private extension HomeViewController {
    // MARK: - Definitions
    typealias DataSource = UICollectionViewDiffableDataSource<SectionKind, CellKind>
    typealias Snapshot = NSDiffableDataSourceSnapshot<SectionKind, CellKind>
    typealias CellKind = RecipeCellModel
    enum SectionKind: String { case main }
    
    func makeCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        .init(sectionProvider: { _, _ in
            let itemHeight: CGFloat = 120

            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(itemHeight))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = .init(top: 0, leading: 10, bottom: 0, trailing: 10)
            section.interGroupSpacing = 20
            return section
        }, configuration: {
            let config = UICollectionViewCompositionalLayoutConfiguration()
            config.scrollDirection = .vertical
            return config
        }())
    }
    
    func makeDataSource() -> DataSource {
        DataSource(collectionView: collectionView) { collectionView, indexPath, cellModel in
            let cell = collectionView.dequeueReusableCell(withClass: RecipeCell.self, for: indexPath)
            cell.configureCell(with: cellModel)
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegate

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath), let id = item.id else {
            return
        }
        viewModel.onOpenRecipeDetails?(id)
    }
}
