//
//  Product.swift
//  Shop
//
//  Created by josh on 2020/07/01.
//  Copyright © 2020 yhkaplan. All rights reserved.
//

import Foundation

struct Product: Hashable {
    let id = UUID()
    let title: String
    let subtitle: String

    init(title: String = "", subtitle: String = "") {
        self.title = title
        self.subtitle = subtitle
    }
}
