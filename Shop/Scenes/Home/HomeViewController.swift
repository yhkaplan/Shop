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
        c.register(SmallSquareCell.self, forCellWithReuseIdentifier: SmallSquareCell.reuseID)
        c.register(MediumSquareCell.self, forCellWithReuseIdentifier: MediumSquareCell.reuseID)
        c.register(LargeSquareCell.self, forCellWithReuseIdentifier: LargeSquareCell.reuseID)

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
            case .circle:
                return collectionView.dequeueReusableCell(
                    withReuseIdentifier: CircleCell.reuseID,
                    for: indexPath
                )
            case .square(let squareKind):
                let reuseID: String
                switch squareKind {
                case .small:
                    reuseID = SmallSquareCell.reuseID
                case .medium:
                    reuseID = MediumSquareCell.reuseID
                case .large:
                    reuseID = LargeSquareCell.reuseID
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

                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.26))
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
                    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3), heightDimension: .fractionalWidth(0.4))
                    let item = NSCollectionLayoutItem(layoutSize: itemSize)

                    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.18))
                    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                    group.interItemSpacing = .flexible(8.0)
                    group.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)

                    let section = NSCollectionLayoutSection(group: group)
                    return section

                case .small:
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

protocol ConfigurableCell {
    func configure(with itemData: Item)
}

extension UILabel {
    func setDynamicFont(to style: UIFont.TextStyle) {
        font = .preferredFont(forTextStyle: style)
        adjustsFontForContentSizeCategory = true
    }
}

final class LargeSquareCell: UICollectionViewCell {
    static let reuseID = "LargeSquareCell"
    private let imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        imageView.backgroundColor = colors.randomElement()!

        contentView.addSubview(imageView)
        imageView.layout(on: contentView) { imageView, contentView in
            imageView.leading == contentView.leading
            imageView.trailing == contentView.trailing
            imageView.top == contentView.top
            imageView.bottom == contentView.bottom
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LargeSquareCell: ConfigurableCell {
    func configure(with itemData: Item) {}
}
final class MediumSquareCell: UICollectionViewCell {
    static let reuseID = "MediumSquareCell"

    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let imageView = UIImageView()
    private let stackView = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        titleLabel.textColor = .label
        titleLabel.setDynamicFont(to: .caption1)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.setDynamicFont(to: .caption2)

        imageView.backgroundColor = colors.randomElement()!
        imageView.layer.cornerRadius = 2.0
        imageView.clipsToBounds = true

        contentView.addSubview(imageView)
        imageView.layout(on: contentView) { imageView, contentView in
            imageView.leading <= contentView.leading
            imageView.trailing <= contentView.trailing
            imageView.top == contentView.top
            imageView.height == imageView.width
            imageView.centerX == contentView.centerX
        }

        stackView.distribution = .fillProportionally
        contentView.addSubview(stackView)
        stackView.layout(on: contentView, otherView: imageView) { stackView, contentView, imageView in
            stackView.top == imageView.bottom + 4.0
            stackView.leading == contentView.leading
            stackView.trailing == contentView.trailing
            stackView.bottom == contentView.bottom
        }

        stackView.axis = .vertical
        stackView.alignment = .center
        [titleLabel, subtitleLabel].forEach(stackView.addArrangedSubview)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MediumSquareCell: ConfigurableCell {

    func configure(with itemData: Item) {
        titleLabel.text = itemData.title
        subtitleLabel.text = itemData.subtitle
    }
}

final class SmallSquareCell: UICollectionViewCell {
    static let reuseID = "SmallSquareCell"

    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let imageView = UIImageView()
    private let stackView = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        titleLabel.textColor = .label
        titleLabel.setDynamicFont(to: .caption1)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.setDynamicFont(to: .caption2)

        imageView.backgroundColor = colors.randomElement()!
        imageView.layer.cornerRadius = 2.0
        imageView.clipsToBounds = true

        contentView.addSubview(imageView)
        imageView.layout(on: contentView) { imageView, contentView in
            imageView.leading == contentView.leading
            imageView.top <= contentView.top
            imageView.bottom <= contentView.bottom
            imageView.width == imageView.height
            imageView.centerY == contentView.centerY
        }

        contentView.addSubview(stackView)
        stackView.layout(on: contentView, otherView: imageView) { stackView, contentView, imageView in
            stackView.top == contentView.top
            stackView.leading == imageView.trailing + 4.0
            stackView.trailing == contentView.trailing
            stackView.bottom == contentView.bottom
        }

        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillEqually
        [titleLabel, subtitleLabel].forEach(stackView.addArrangedSubview)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SmallSquareCell: ConfigurableCell {

    func configure(with itemData: Item) {
        titleLabel.text = itemData.title
        subtitleLabel.text = itemData.subtitle
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
