//
//  HomeRouter.swift
//  Shop
//
//  Created by josh on 2020/07/16.
//  Copyright © 2020 yhkaplan. All rights reserved.
//

import SwiftUI
import UIKit

protocol HomeRouterType {
    func pushProductDetailView(product: Product)
}

final class HomeRouter: HomeRouterType {
    private unowned let viewController: Transitionable

    init(viewController: Transitionable) {
        self.viewController = viewController
    }

    func pushProductDetailView(product: Product) {
        let productDetailView = ProductDetailView(product: product)
        viewController.pushView(productDetailView, animated: true)
    }
}
