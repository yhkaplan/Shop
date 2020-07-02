//
//  ShortcutCell.swift
//  Shop
//
//  Created by josh on 2020/07/01.
//  Copyright © 2020 yhkaplan. All rights reserved.
//

import UIKit

final class ShortcutCell: UICollectionViewCell, ConfigurableCell {
    static let reuseID = "ShortcutCell"
    private let imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = bounds.width / 2.0
        clipsToBounds = true

        imageView.backgroundColor = .systemGray6
        imageView.contentMode = .scaleAspectFit

        contentView.addSubview(imageView)
        imageView.layout(on: contentView) { imageView, contentView in
            imageView.leading == contentView.leading
            imageView.trailing == contentView.trailing
            imageView.top == contentView.top
            imageView.bottom == contentView.bottom
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with data: Shortcut) {
        imageView.image = UIImage(systemName: data.imageURL)?
            .withTintColor(.systemGray, renderingMode: .alwaysOriginal)
    }
}
