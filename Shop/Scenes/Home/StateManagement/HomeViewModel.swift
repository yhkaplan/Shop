//
//  HomeViewModel.swift
//  Shop
//
//  Created by josh on 2020/07/02.
//  Copyright © 2020 yhkaplan. All rights reserved.
//

import Foundation
import Combine

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

final class HomeViewModel {
    private let store: Store<HomeState, HomeAction, HomeEnvironment>
    private let router: HomeRouterType

    var statePublisher: Published<HomeState>.Publisher { store.$state }

    init(
        store: Store<HomeState, HomeAction, HomeEnvironment>,
        router: HomeRouterType
    ) {
        self.store = store
        self.router = router
    }

    func viewDidLoad() {
        store.send(.loadSectionData)
    }

    func pullToRefreshGestureDidRecognize() {
        store.send(.loadSectionData)
    }

    func didTapCell(section: Int, item: Int) {
        let section = store.state.sections.keys.sorted(by: <)[section]
        let item = store.state.sections[section]?[item]

        switch item {
        case .product(let product):
            router.pushProductDetailView(product: product)

        default: fatalError() // TODO:
        }
    }
}
