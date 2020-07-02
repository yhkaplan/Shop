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

final class HomeViewController: UIViewController {

    private lazy var collectionView: UICollectionView = {
        let c = UICollectionView(frame: view.bounds, collectionViewLayout: makeCollectionViewLayout())

        c.delegate = self
        c.registerCell(ShortcutCell.self)
        c.registerCell(ArticleCell.self)
        c.registerCell(ProductCell.self)
        c.registerCell(BannerCell.self)

        c.register(HeaderView.self, forSupplementaryViewOfKind: HeaderView.kind, withReuseIdentifier: HeaderView.reuseID)

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

            switch sectionKind {
            case .shortcut:
                guard case let .shortcut(shortcut) = item else { return nil }
                return collectionView.configureReusableCell(ShortcutCell.self, data: shortcut, for: indexPath)

            case .featuredProduct:
                guard case let .product(product) = item else { return nil }
                return collectionView.configureReusableCell(ProductCell.self, data: product, for: indexPath)

            case .article:
                guard case let .article(article) = item else { return nil }
                return collectionView.configureReusableCell(ArticleCell.self, data: article, for: indexPath)

            case .banner:
                guard case let .banner(banner) = item else { return nil }
                return collectionView.configureReusableCell(BannerCell.self, data: banner, for: indexPath)
            }
        }
    }()

    private lazy var refreshControl: UIRefreshControl = {
        let r = UIRefreshControl()
        r.addTarget(self, action: #selector(refreshAll), for: .valueChanged)
        return r
    }()
    private let apiClient = APIClient()
    private var cancellables = Set<AnyCancellable>()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.refreshControl = refreshControl
        dataSource.supplementaryViewProvider = { [weak self] view, kind, indexPath in
            guard let strongSelf = self else { return nil }
            let header = self?.collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: HeaderView.reuseID,
                for: indexPath
            ) as? HeaderView
            let section = strongSelf.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            header?.configure(with: (title: section.title, subtitle: section.subtitle))

            return header
        }
        downloadData()
    }

    @objc private func refreshAll() {
        var snapshot = self.dataSource.snapshot()
        snapshot.deleteAllItems()
        dataSource.apply(snapshot)
        downloadData()
    }

    private func makeCollectionViewLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, environment in
            guard let self = self else { return nil }

            let snapshot = self.dataSource.snapshot()
            let section = snapshot.sectionIdentifiers[sectionIndex]

            let sectionIsEmpty = snapshot.numberOfItems(inSection: section) == 0
            if sectionIsEmpty { return nil }

            switch section.kind { // TODO: provide zero height layout while loading
            case .shortcut:
                let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(80), heightDimension: .absolute(80))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)

                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(100))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                group.interItemSpacing = .flexible(8.0)

                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 0.0
                section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
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

                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(340.0))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                group.interItemSpacing = .flexible(8.0)

                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
                section.interGroupSpacing = 10


                let header = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: .init(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .estimated(50.0)
                    ),
                    elementKind: HeaderView.kind,
                    alignment: .top
                )
                section.boundarySupplementaryItems = [header]

                return section

            case .article:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.3))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)

                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.25))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                group.interItemSpacing = .flexible(8.0)

                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 30, leading: 20, bottom: 20, trailing: 20)
                return section
            }
        }
    }

    private func downloadData() { // TODO: move all this to separate class unaware of DiffableDataSources and testable
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([]) // Initialize snapshot TODO: needed?
        dataSource.apply(snapshot, animatingDifferences: true)

        apiClient.request(endpoint: GETHomeContentEndpoint())
            .receive(on: DispatchQueue.main) // Runloop.main?
            .sink(receiveCompletion: {error in}, receiveValue: { [weak self] homeSections in
                guard let strongSelf = self else { return }
                var snapshot = strongSelf.dataSource.snapshot()
                snapshot.appendSections(homeSections.sections)
                strongSelf.dataSource.apply(snapshot, animatingDifferences: true) { // Only modify snapshot when finished
                    strongSelf.refreshControl.endRefreshing()

                    homeSections.sections.forEach { section in
                        switch section.kind {
                        case .article:
                            strongSelf.apiClient.request(endpoint: GETArticlesEndpoint(id: section.id))
                                .receive(on: DispatchQueue.main) // Runloop.main?
                                .sink(receiveCompletion: {error in}, receiveValue: { articles in
                                    let items: [Item] = articles.articles.map { .article($0) }
                                    var snapshot = strongSelf.dataSource.snapshot()
                                    snapshot.appendItems(items, toSection: section)
                                    strongSelf.dataSource.apply(snapshot)
                                })
                                .store(in: &strongSelf.cancellables)

                        case .featuredProduct:
                            strongSelf.apiClient.request(endpoint: GETFeaturedProductsEndpoint(id: section.id))
                                .receive(on: DispatchQueue.main) // Runloop.main?
                                .sink(receiveCompletion: {error in}, receiveValue: { products in
                                    let items: [Item] = products.products.map { .product($0) }
                                    var snapshot = strongSelf.dataSource.snapshot()
                                    snapshot.appendItems(items, toSection: section)
                                    strongSelf.dataSource.apply(snapshot)
                                })
                                .store(in: &strongSelf.cancellables)
                        case .shortcut:
                            strongSelf.apiClient.request(endpoint: GETShortcutsEndpoint(id: section.id))
                                .receive(on: DispatchQueue.main) // Runloop.main?
                                .sink(receiveCompletion: {error in}, receiveValue: { shortcuts in
                                    let items: [Item] = shortcuts.shortcuts.map { .shortcut($0) }
                                    var snapshot = strongSelf.dataSource.snapshot()
                                    snapshot.appendItems(items, toSection: section)
                                    strongSelf.dataSource.apply(snapshot)
                                })
                                .store(in: &strongSelf.cancellables)
                        case .banner:
                            strongSelf.apiClient.request(endpoint: GETBannersEndpoint(id: section.id))
                                .receive(on: DispatchQueue.main) // Runloop.main?
                                .sink(receiveCompletion: {error in}, receiveValue: { banners in
                                    let items: [Item] = banners.banners.map { .banner($0) }
                                    var snapshot = strongSelf.dataSource.snapshot()
                                    snapshot.appendItems(items, toSection: section)
                                    strongSelf.dataSource.apply(snapshot)
                                })
                                .store(in: &strongSelf.cancellables)
                        }
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

    enum Item: Hashable { case product(Product), article(Article), banner(Banner), shortcut(Shortcut) }

    struct Section: Hashable, Decodable {
        let id: Int // TODO: make ID type-safe
        let kind: Kind
        let title: String?
        let subtitle: String?

        enum Kind: String, Hashable {
            case banner, shortcut, article
            case featuredProduct = "featured_product"
        }
    }
}

extension HomeViewController.Section: Comparable {
    static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.id < rhs.id
    }
}

extension HomeViewController.Section.Kind: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawString = try container.decode(String.self)
        guard let kind = Self(rawValue: rawString) else { throw DecoderError.cannotParse }
        self = kind
    }
}
