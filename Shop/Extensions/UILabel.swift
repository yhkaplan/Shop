//
//  UIFontExtensions.swift
//  Shop
//
//  Created by josh on 2020/07/01.
//  Copyright © 2020 yhkaplan. All rights reserved.
//

import UIKit

extension UILabel {
    func setDynamicFont(to style: UIFont.TextStyle) {
        font = .preferredFont(forTextStyle: style)
        adjustsFontForContentSizeCategory = true
    }
}
