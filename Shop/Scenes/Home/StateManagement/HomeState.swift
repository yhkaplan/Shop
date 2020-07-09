//
//  HomeState.swift
//  Shop
//
//  Created by josh on 2020/07/09.
//  Copyright © 2020 yhkaplan. All rights reserved.
//

import Foundation

enum ProductDetailPresentedState {
    case presented(Product)
    case notPresented
}

struct HomeState {
    var sections: [HomeViewController.Section: [HomeViewController.Item]] = [:]
    var isRefreshControlAnimating = false
    var productDetailScreenIsPresented: ProductDetailPresentedState = .notPresented
}
