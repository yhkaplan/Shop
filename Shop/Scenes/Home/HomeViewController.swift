//
//  HomeViewController.swift
//  Shop
//
//  Created by josh on 2020/06/18.
//  Copyright © 2020 yhkaplan. All rights reserved.
//

import UIKit
import Combine

let colors: [UIColor] = [.blue, .cyan, .darkGray, .gray, .green, .magenta, .purple, .red, .yellow]

protocol ConfigurableCell {
    func configure(with itemData: Product)
}

final class HomeViewController: UIViewController {

    private lazy var collectionView: UICollectionView = {
        let c = UICollectionView(frame: view.bounds, collectionViewLayout: makeCollectionViewLayout())

        c.delegate = self
        c.register(ShortcutCell.self, forCellWithReuseIdentifier: ShortcutCell.reuseID)
        c.register(ArticleCell.self, forCellWithReuseIdentifier: ArticleCell.reuseID)
        c.register(ProductCell.self, forCellWithReuseIdentifier: ProductCell.reuseID)
        c.register(BannerCell.self, forCellWithReuseIdentifier: BannerCell.reuseID)

        c.backgroundColor = .systemBackground

        view.addSubview(c)
        c.layout(on: view) { c, view in
            c.leading == view.leading
            c.trailing == view.trailing
            c.top == view.top
            c.bottom == view.bottom
        }

        return c
    }()

    private lazy var dataSource: UICollectionViewDiffableDataSource<Section, Item> = {
        .init(collectionView: collectionView) { [weak self] collectionView, indexPath, item in
            guard let self = self else { return nil }

            let snapshot = self.dataSource.snapshot()
            let sectionKind = snapshot.sectionIdentifiers[indexPath.section].kind

            // TODO: think of a more generic approach
            switch sectionKind {
            case .shortcut:
                return collectionView.dequeueReusableCell(
                    withReuseIdentifier: ShortcutCell.reuseID,
                    for: indexPath
                )
            case .featuredProduct:
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: ProductCell.reuseID,
                    for: indexPath
                    ) as? ProductCell
                guard case let .product(product) = item else { return nil }
                cell?.configure(with: product)
                return cell

            case .article:
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: ArticleCell.reuseID,
                    for: indexPath
                    ) as? ArticleCell
                guard case let .article(article) = item else { return nil }
                cell?.configure(with: article)
                return cell

            case .banner:
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: BannerCell.reuseID,
                    for: indexPath
                ) as? BannerCell
                guard case let .banner(banner) = item else { return nil }
                cell?.configure(with: banner)
                return cell
            }
        }
    }()

    private let apiClient = APIClient()
    private var cancellables = Set<AnyCancellable>()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        downloadData()
    }

    func makeCollectionViewLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, environment in
            guard let self = self else { return nil }

            let snapshot = self.dataSource.snapshot()
            let sectionKind = snapshot.sectionIdentifiers[sectionIndex].kind

            switch sectionKind {
            case .shortcut:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.23), heightDimension: .fractionalWidth(0.23))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)

                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.26))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                group.interItemSpacing = .flexible(8.0)
                group.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)

                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 0.0
                return section

            case .banner:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)

                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.8))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .paging
                return section

            case .featuredProduct:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3), heightDimension: .fractionalWidth(0.45))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)

                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.2))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                group.interItemSpacing = .flexible(8.0)
                group.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)

                let section = NSCollectionLayoutSection(group: group)
                return section

            case .article:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.3))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)

                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.25))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                group.interItemSpacing = .flexible(8.0)

                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 30, leading: 20, bottom: 10, trailing: 20)
                return section
            }
        }
    }

    func downloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([])
        dataSource.apply(snapshot, animatingDifferences: false)

        apiClient.request(endpoint: GETHomeContentEndpoint())
            .print()
            .sink(receiveCompletion: {error in}, receiveValue: { [weak self] homeSections in
                guard let self = self else { return }
                homeSections.sections.forEach { section in
                    switch section.kind {
                    case .article:

                        self.apiClient.request(endpoint: GETArticlesEndpoint(id: section.id))
                            .print()
                            .receive(on: DispatchQueue.main) // Runloop.main?
                            .sink(receiveCompletion: {error in}, receiveValue: { articles in
                                let sections: [Section] = [.init(kind: .article, items: articles.articles.map { .article($0) })]
                                var snapshot = self.dataSource.snapshot()
                                // TODO use Combine to map these? self.dataSource.publisher(for: )
                                snapshot.appendSections(sections)
                                sections.forEach { snapshot.appendItems($0.items, toSection: $0) }
                                self.dataSource.apply(snapshot, animatingDifferences: true)
                            })
                            .store(in: &self.cancellables)

                    case .featuredProduct, .shortcut, .banner:

                        self.apiClient.request(endpoint: GETFeaturedProductsEndpoint(id: section.id))
                            .print()
                            .receive(on: DispatchQueue.main) // Runloop.main?
                            .sink(receiveCompletion: {error in}, receiveValue: { products in
                                let sections: [Section] = [.init(kind: .featuredProduct, items: products.products.map { .product($0) })]
                                var snapshot = self.dataSource.snapshot()
                                // TODO use Combine to map these? self.dataSource.publisher(for: )
                                snapshot.appendSections(sections)
                                sections.forEach { snapshot.appendItems($0.items, toSection: $0) }
                                self.dataSource.apply(snapshot, animatingDifferences: true)
                            })
                            .store(in: &self.cancellables)
                    }
                }
            })
            .store(in: &cancellables)

    }
}

// TODO: make separate DelegateAdaptor class conform and use closure or combine-based API
extension HomeViewController: UICollectionViewDelegate {

}

extension HomeViewController {

    enum Item: Hashable { case product(Product), article(Article), banner(Banner) }

    struct Section: Hashable {
        let id = UUID()
        let kind: HomeSectionKind
        let title: String?
        let subtitle: String?
        let items: [Item]

        init(kind: HomeSectionKind, title: String = "", subtitle: String = "", items: [Item]) {
            self.kind = kind
            self.title = title
            self.subtitle = subtitle
            self.items = items
        }
    }

}
