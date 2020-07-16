//
//  HeaderView.swift
//  Shop
//
//  Created by josh on 2020/07/02.
//  Copyright © 2020 yhkaplan. All rights reserved.
//

import UIKit

final class HeaderView: UICollectionReusableView {
    static let kind = UICollectionView.elementKindSectionHeader
    static let reuseID = "HeaderView"

    private let stackView = UIStackView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        titleLabel.textColor = .label
        titleLabel.setDynamicFont(to: .title2)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.setDynamicFont(to: .title3)

        addSubview(stackView)
        stackView.layout(on: self) { stackView, view in
            stackView.leading == view.leading
            stackView.trailing == view.trailing
            stackView.bottom == view.bottom
            stackView.top == view.top
        }

        stackView.axis = .vertical
        stackView.alignment = .leading
        [titleLabel, subtitleLabel].forEach(stackView.addArrangedSubview)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with data: (title: String?, subtitle: String?)) {
        titleLabel.text = data.title
        subtitleLabel.text = data.subtitle
    }
}
