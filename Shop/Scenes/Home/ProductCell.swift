//
//  MediumProductCell.swift
//  Shop
//
//  Created by josh on 2020/07/01.
//  Copyright © 2020 yhkaplan. All rights reserved.
//

import UIKit

final class ProductCell: UICollectionViewCell, ConfigurableCell {
    static let reuseID = "ProductCell"

    private let productNameLabel = UILabel()
    private let priceLabel = UILabel()
    private let imageView = UIImageView()
    private let stackView = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        productNameLabel.textColor = .label
        productNameLabel.setDynamicFont(to: .caption1)
        productNameLabel.numberOfLines = 2
        productNameLabel.textAlignment = .center
        priceLabel.textColor = .secondaryLabel
        priceLabel.setDynamicFont(to: .caption2)

        imageView.layer.cornerRadius = 2.0
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = colors.randomElement()!

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
        [productNameLabel, priceLabel].forEach(stackView.addArrangedSubview)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with data: Product) {
        productNameLabel.text = data.name
        priceLabel.text = data.formattedPrice
        // This is obviously not an appropriate way to handle images and is just for demo purposes
        imageView.image = UIImage(systemName: data.imageURL)
    }
}
