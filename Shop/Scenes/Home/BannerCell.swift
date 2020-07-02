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

        imageView.contentMode = .scaleAspectFit

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

    func configure(with banner: Banner) {
        imageView.image = UIImage(systemName: banner.imageURL)
    }
}
