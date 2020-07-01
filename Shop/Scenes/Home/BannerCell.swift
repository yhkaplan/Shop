//
//  BannerCell.swift
//  Shop
//
//  Created by josh on 2020/07/01.
//  Copyright © 2020 yhkaplan. All rights reserved.
//

import UIKit

final class BannerCell: UICollectionViewCell {
    static let reuseID = "BannerCell"
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

extension BannerCell: ConfigurableCell {
    func configure(with itemData: Product) {}
}
