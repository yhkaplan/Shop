//
//  HomeReducer.swift
//  Shop
//
//  Created by josh on 2020/07/09.
//  Copyright © 2020 yhkaplan. All rights reserved.
//

import Foundation
import Combine

final class HomeActionCreator {
    private let dispatcher: Dispatcher<HomeAction>
    private let environment: HomeEnvironment
    private var cancellables = Set<AnyCancellable>()

    // input action
    private let _load = PassthroughSubject<Void, Never>()
    private let _didTapCell = PassthroughSubject<(section: Int, item: Int), Never>()

    // output action can use @Published?
    private let sections = PassthroughSubject<[HomeViewController.Section: [HomeViewController.Item]], Never>()
    private let isActivityIndicatorHidden = PassthroughSubject<Bool, Never>()
    private let isRefreshIndicatorAnimating = PassthroughSubject<Bool, Never>()
    private let productDetailScreenIsPresented = PassthroughSubject<PresentedState<Product>, Never>()

    init(dispatcher: Dispatcher<HomeAction>, environment: HomeEnvironment) {
        self.dispatcher = dispatcher
        self.environment = environment

        _load.sink { [weak self] _ in
            guard let strongSelf = self else { return}
            strongSelf.environment.homeService.homeContentPublisher()
                .replaceError(with: [])
                .sink(receiveValue: { sections in
                    strongSelf.environment.homeService.sectionItemsPublisher(sections: sections)
                        .replaceError(with: [:])
                        .receive(on: DispatchQueue.main)
                        .sink(receiveValue: { sections in
                            strongSelf.dispatcher.dispatch(.setSections(sections: sections))
                        }).store(in: &strongSelf.cancellables)
                }).store(in: &strongSelf.cancellables)
        }.store(in: &cancellables)

        _didTapCell.sink { [weak self] (section, item) in
            self?.dispatcher.dispatch(.didTapCell(section: section, item: item))
        }.store(in: &cancellables)
    }

    // MARK: - Input

    func didTapCell(section: Int, item: Int) {
        _didTapCell.send((section: section, item: item))
    }

    func didPullToRefresh() {
        _load.send()
    }

    func viewDidLoad() {
        _load.send()
    }
}
