//
//  ArticleCell.swift
//  Shop
//
//  Created by josh on 2020/07/01.
//  Copyright © 2020 yhkaplan. All rights reserved.
//

import UIKit

final class ArticleCell: UICollectionViewCell, ConfigurableCell {
    static let reuseID = "ArticleCell"

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
        subtitleLabel.numberOfLines = 2

        imageView.backgroundColor = .systemGray6
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

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with data: Article) {
        titleLabel.text = data.title
        subtitleLabel.text = data.subtitle
        imageView.image = UIImage(systemName: data.imageURL)?
            .withTintColor(.systemGray, renderingMode: .alwaysOriginal)
    }
}
