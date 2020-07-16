//
//  HomeReducer.swift
//  Shop
//
//  Created by josh on 2020/07/09.
//  Copyright © 2020 yhkaplan. All rights reserved.
//

import Foundation
import Combine

final class HomePresenter: ObservableObject {
    private let interactor: HomeInteractor
    private let router: HomeRouterType

    private var cancellables = Set<AnyCancellable>()

    @Published var sections: [HomeViewController.Section: [HomeViewController.Item]] = [:]
    @Published var isLoading = false

    init(interactor: HomeInteractor, router: HomeRouterType) {
        self.interactor = interactor
        self.router = router

        interactor.model.$sections
            .assign(to: \.sections, on: self)
            .store(in: &cancellables)

        interactor.model.$isLoading
            .assign(to: \.isLoading, on: self)
            .store(in: &cancellables)
    }

    func didTapCell(section: Int, item: Int) {
        let section = sections.keys.sorted(by: <)[section]
        let item = sections[section]?[item]

        switch item {
        case .product(let product):
            router.pushProductDetailView(product: product)

        default: fatalError() // TODO:
        }
    }

    func didPullToRefresh() {
        interactor.loadData()
    }

    func viewDidLoad() {
        interactor.loadData()
    }
}
