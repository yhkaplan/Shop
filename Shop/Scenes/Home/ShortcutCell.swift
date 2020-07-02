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

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = colors.randomElement()!
        layer.cornerRadius = bounds.width / 2.0
        clipsToBounds = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with data: Shortcut) {}
}
