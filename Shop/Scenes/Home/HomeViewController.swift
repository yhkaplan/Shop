//
//  HomeViewController.swift
//  Shop
//
//  Created by josh on 2020/06/18.
//  Copyright © 2020 yhkaplan. All rights reserved.
//

import UIKit

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

            let reuseID: String

            switch sectionKind {
            case .shortcut:
                return collectionView.dequeueReusableCell(
                    withReuseIdentifier: ShortcutCell.reuseID,
                    for: indexPath
                )
            case .pickupProduct:
                reuseID = ProductCell.reuseID
            case .article:
                reuseID = ArticleCell.reuseID
            case .banner:
                reuseID = BannerCell.reuseID
            }

            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: reuseID,
                for: indexPath
            ) as? ConfigurableCell & UICollectionViewCell
            cell?.configure(with:
                .init(
                    title: "Product \(UUID().uuidString)",
                    subtitle: "$42"
                )
            )
            return cell
        }
    }()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        addData()
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

            case .pickupProduct:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3), heightDimension: .fractionalWidth(0.4))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)

                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.18))
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

    func addData() {
        let sections: [Section] = [
            .init(kind: .banner, title: "Squares", subtitle: "", items: [
                .product(.init(title: "a", subtitle: "a")),
                .product(.init(title: "a", subtitle: "a")),
                .product(.init(title: "a", subtitle: "a")),
                .product(.init(title: "a", subtitle: "a")),
                .product(.init(title: "a", subtitle: "a")),
                .product(.init(title: "a", subtitle: "a")),
                .product(.init(title: "a", subtitle: "a")),
                .product(.init(title: "a", subtitle: "a")),
                .product(.init(title: "a", subtitle: "a")),
                .product(.init(title: "a", subtitle: "a")),
                .product(.init(title: "a", subtitle: "a")),
                .product(.init(title: "a", subtitle: "a")),
            ]),
            .init(
                kind: .shortcut,
                title: "Circles",
                subtitle: "",
                items: [
                    .product(.init(title: "a", subtitle: "a")),
                    .product(.init(title: "a", subtitle: "a")),
                    .product(.init(title: "a", subtitle: "a")),
                    .product(.init(title: "a", subtitle: "a")),
                ]
            ),
            .init(kind: .pickupProduct, title: "Squares", subtitle: "", items: [
                .product(.init(title: "a", subtitle: "a")),
                .product(.init(title: "a", subtitle: "a")),
                .product(.init(title: "a", subtitle: "a")),
                .product(.init(title: "a", subtitle: "a")),
                .product(.init(title: "a", subtitle: "a")),
                .product(.init(title: "a", subtitle: "a")),
            ]),
            .init(kind: .article, title: "Squares", subtitle: "", items: [
                .product(.init(title: "a", subtitle: "a")),
                .product(.init(title: "a", subtitle: "a")),
                .product(.init(title: "a", subtitle: "a")),
            ]),
            .init(kind: .pickupProduct, title: "Squares", subtitle: "", items: [
                .product(.init(title: "a", subtitle: "a")),
                .product(.init(title: "a", subtitle: "a")),
                .product(.init(title: "a", subtitle: "a")),
                .product(.init(title: "a", subtitle: "a")),
                .product(.init(title: "a", subtitle: "a")),
                .product(.init(title: "a", subtitle: "a")),
            ]),
        ]

        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections(sections)
        sections.forEach { snapshot.appendItems($0.items, toSection: $0) }
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

// TODO: make separate DelegateAdaptor class conform and use closure or combine-based API
extension HomeViewController: UICollectionViewDelegate {

}

extension HomeViewController {

    enum Item: Hashable { case product(Product) }

    struct Section: Hashable {
        let id = UUID()
        let kind: Kind
        let title: String
        let subtitle: String
        let items: [Item]

        init(kind: Kind, title: String = "", subtitle: String = "", items: [Item]) {
            self.kind = kind
            self.title = title
            self.subtitle = subtitle
            self.items = items
        }

        enum Kind: Hashable {
            case banner
            case shortcut
            case pickupProduct
            case article
        }
    }

}
