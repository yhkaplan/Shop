//
//  UINavigationController.swift
//  Shop
//
//  Created by josh on 2020/07/09.
//  Copyright © 2020 yhkaplan. All rights reserved.
//

import UIKit
import SwiftUI

extension UINavigationController {
    func pushView<Content: View>(_ view: Content, animated: Bool = true) {
        pushViewController(UIHostingController(rootView: view), animated: animated)
    }
}
