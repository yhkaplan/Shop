//
//  HomeViewController.swift
//  Shop
//
//  Created by josh on 2020/06/18.
//  Copyright © 2020 yhkaplan. All rights reserved.
//

import UIKit
import Combine

final class HomeViewController: UIViewController, Transitionable {

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

    private var presenter: HomePresenter!
    private var cancellables = Set<AnyCancellable>()

    init() {
        super.init(nibName: nil, bundle: nil)
        // TODO: all this initialization logic might be in an object called `HomeModule`
        let interactor = HomeInteractor(model: HomeDataModel(), homeProvider: HomeProvider())
        let presenter = HomePresenter(interactor: interactor, router: HomeRouter(viewController: self))
        self.presenter = presenter
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateSections(_ sections: [Section : [Item]]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections(Array(sections.keys.sorted(by: <)))
        for (section, items) in sections {
            snapshot.appendItems(items, toSection: section)
        }

        dataSource.apply(snapshot, animatingDifferences: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Awesome Shop"

        presenter.$isLoading.sink { [weak self] isLoading in
            if isLoading { return }
            self?.refreshControl.endRefreshing()
        }.store(in: &cancellables)

        presenter.$sections.sink { [weak self] sections in
            self?.updateSections(sections)
        }.store(in: &cancellables)

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

        presenter.viewDidLoad()
    }

    @objc private func refreshAll() {
        var snapshot = self.dataSource.snapshot() // TODO: this reset logic should be in presenter
        snapshot.deleteAllItems()
        dataSource.apply(snapshot)

        presenter.didPullToRefresh()
    }

    private func makeCollectionViewLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, environment in
            guard let self = self else { return nil }

            let snapshot = self.dataSource.snapshot()
            let section = snapshot.sectionIdentifiers[sectionIndex]

            let sectionIsEmpty = snapshot.numberOfItems(inSection: section) == 0
            if sectionIsEmpty { return nil }

            switch section.kind {
            case .shortcut:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.2), heightDimension: .fractionalWidth(0.2))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)

                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.22))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                group.interItemSpacing = .flexible(8.0)

                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 0.0
                section.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 20, bottom: 12, trailing: 20)
                return section

            case .banner:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)

                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.62))
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

}

// TODO: make separate DelegateAdaptor class conform and use closure or combine-based API
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.didTapCell(section: indexPath.section, item: indexPath.item)
    }
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
