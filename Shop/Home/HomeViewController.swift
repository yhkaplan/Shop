//
//  HomeViewController.swift
//  Shop
//
//  Created by josh on 2020/06/18.
//  Copyright © 2020 yhkaplan. All rights reserved.
//

import UIKit

final class HomeViewController: UIViewController {

    private lazy var collectionView: UICollectionView = {
        let c = UICollectionView(frame: view.bounds, collectionViewLayout: makeCollectionViewLayout())

        c.delegate = self
        c.register(CircleCell.self, forCellWithReuseIdentifier: CircleCell.reuseID)
        c.register(SquareCell.self, forCellWithReuseIdentifier: SquareCell.reuseID)

        c.backgroundColor = .systemBackground

        c.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(c)
        NSLayoutConstraint.activate([
            c.topAnchor.constraint(equalTo: view.topAnchor),
            c.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            c.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            c.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        return c
    }()

    private lazy var dataSource: UICollectionViewDiffableDataSource<Section, Item> = {
        .init(collectionView: collectionView) { [weak self] collectionView, indexPath, item in
            guard let self = self else { return nil }

            let snapshot = self.dataSource.snapshot()
            let sectionKind = snapshot.sectionIdentifiers[indexPath.section].kind

            switch sectionKind {
            case .circle(let circleType):
                return collectionView.dequeueReusableCell(
                    withReuseIdentifier: CircleCell.reuseID,
                    for: indexPath
                )
            case .square:
                return collectionView.dequeueReusableCell(
                    withReuseIdentifier: SquareCell.reuseID,
                    for: indexPath
                )
            }
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
            case .circle:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.23), heightDimension: .fractionalWidth(0.23))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)

                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(120.0))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                group.interItemSpacing = .flexible(8.0)
                group.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)

                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 0.0
                return section

            case .square(let squareKind):
                switch squareKind {
                case .large:
                    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                    let item = NSCollectionLayoutItem(layoutSize: itemSize)

                    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.8))
                    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

                    let section = NSCollectionLayoutSection(group: group)
                    section.orthogonalScrollingBehavior = .paging
                    return section

                case .medium:
                    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3), heightDimension: .fractionalWidth(0.3))
                    let item = NSCollectionLayoutItem(layoutSize: itemSize)

                    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(140))
                    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                    group.interItemSpacing = .flexible(8.0)
                    group.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)

                    let section = NSCollectionLayoutSection(group: group)
//                    section.interGroupSpacing = 0.0
                    return section

                case .small:
                    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.15), heightDimension: .fractionalWidth(0.15))
                    let item = NSCollectionLayoutItem(layoutSize: itemSize)

                    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(90))
                    let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                    group.interItemSpacing = .flexible(8.0)
                    group.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)

                    let section = NSCollectionLayoutSection(group: group)
                    //                    section.interGroupSpacing = 0.0
                    return section
                }
            }
        }
    }

    func addData() {
        let sections: [Section] = [
            .init(kind: .square(.large), title: "Squares", subtitle: "", items: [
                Item(title: "a", subtitle: "a"),
                Item(title: "a", subtitle: "a"),
                Item(title: "a", subtitle: "a"),
                Item(title: "a", subtitle: "a"),
                Item(title: "a", subtitle: "a"),
                Item(title: "a", subtitle: "a"),
                Item(title: "a", subtitle: "a"),
                Item(title: "a", subtitle: "a"),
                Item(title: "a", subtitle: "a"),
                Item(title: "a", subtitle: "a"),
                Item(title: "a", subtitle: "a"),
                Item(title: "a", subtitle: "a"),
            ]),
            .init(
                kind: .circle(.normal),
                title: "Circles",
                subtitle: "",
                items: [
                    Item(title: "a", subtitle: "a"),
                    Item(title: "a", subtitle: "a"),
                    Item(title: "a", subtitle: "a"),
                    Item(title: "a", subtitle: "a"),
                ]
            ),
            .init(kind: .square(.medium), title: "Squares", subtitle: "", items: [
                Item(title: "a", subtitle: "a"),
                Item(title: "a", subtitle: "a"),
                Item(title: "a", subtitle: "a"),
                Item(title: "a", subtitle: "a"),
                Item(title: "a", subtitle: "a"),
                Item(title: "a", subtitle: "a"),
            ]),
            .init(kind: .square(.small), title: "Squares", subtitle: "", items: [
                Item(title: "a", subtitle: "a"),
                Item(title: "a", subtitle: "a"),
                Item(title: "a", subtitle: "a"),
            ]),
            .init(kind: .square(.medium), title: "Squares", subtitle: "", items: [
                Item(title: "a", subtitle: "a"),
                Item(title: "a", subtitle: "a"),
                Item(title: "a", subtitle: "a"),
                Item(title: "a", subtitle: "a"),
                Item(title: "a", subtitle: "a"),
                Item(title: "a", subtitle: "a"),
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


// TODO: replace w/ original code
struct Item: Hashable {
    let id = UUID()
    let title: String
    let subtitle: String

    init(title: String = "", subtitle: String = "") {
        self.title = title
        self.subtitle = subtitle
    }
}
struct Section: Hashable {
    let id = UUID()
    let kind: Kind
    let title: String
    let subtitle: String
    let items: [Item]

    init(kind: Kind, title: String = "", subtitle: String = "", items: [Item] = []) {
        self.kind = kind
        self.title = title
        self.subtitle = subtitle
        self.items = items
    }

    enum Circle: String { case normal }
    enum Square: String { case small, medium, large }

    enum Kind: Hashable {
        case circle(Circle)
        case square(Square)
    }
}

let colors: [UIColor] = [.blue, .cyan, .darkGray, .gray, .green, .magenta, .purple, .red, .yellow]

final class SquareCell: UICollectionViewCell {
    static let reuseID = "SquareCell"

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = colors.randomElement()!
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class CircleCell: UICollectionViewCell {
    static let reuseID = "CircleCell"

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = colors.randomElement()!
        layer.cornerRadius = bounds.width / 2.0
        clipsToBounds = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
