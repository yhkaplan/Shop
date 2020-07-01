//
//  MediumProductCell.swift
//  Shop
//
//  Created by josh on 2020/07/01.
//  Copyright © 2020 yhkaplan. All rights reserved.
//

import UIKit

final class ProductCell: UICollectionViewCell {
    static let reuseID = "ProductCell"

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

extension ProductCell: ConfigurableCell {

    func configure(with itemData: Product) {
        titleLabel.text = itemData.title
        subtitleLabel.text = itemData.subtitle
    }
}