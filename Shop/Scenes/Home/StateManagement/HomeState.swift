//
//  HomeState.swift
//  Shop
//
//  Created by josh on 2020/07/09.
//  Copyright © 2020 yhkaplan. All rights reserved.
//

import Foundation

enum PresentedState<T: Equatable>: Equatable {
    case presented(T)
    case notPresented
}

struct HomeState: Equatable {
    var sections: [HomeViewController.Section: [HomeViewController.Item]] = [:]
    var isSectionLoading = false
    var productDetailScreenIsPresented: PresentedState<Product> = .notPresented
}
