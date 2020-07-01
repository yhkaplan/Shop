//
//  ArticleCell.swift
//  Shop
//
//  Created by josh on 2020/07/01.
//  Copyright © 2020 yhkaplan. All rights reserved.
//

import UIKit

final class ArticleCell: UICollectionViewCell {
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

extension ArticleCell: ConfigurableCell {

    func configure(with itemData: Product) {
        titleLabel.text = itemData.title
        subtitleLabel.text = itemData.subtitle
    }
}
