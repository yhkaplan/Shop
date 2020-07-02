//
//  UICollectionView.swift
//  Shop
//
//  Created by josh on 2020/07/02.
//  Copyright © 2020 yhkaplan. All rights reserved.
//

import UIKit

protocol ConfigurableCell {
    associatedtype Data
    static var reuseID: String { get }
    func configure(with data: Data)
}
extension UICollectionView {
    func registerCell<Cell: ConfigurableCell & UICollectionViewCell>(_ type: Cell.Type) {
        register(type.self, forCellWithReuseIdentifier: type.reuseID)
    }

    func configureReusableCell<Cell: ConfigurableCell & UICollectionViewCell>(_ type: Cell.Type, data: Cell.Data, for indexPath: IndexPath) -> UICollectionViewCell? {
        let cell = dequeueReusableCell(withReuseIdentifier: Cell.reuseID, for: indexPath) as? Cell
        cell?.configure(with: data)
        return cell
    }
}

