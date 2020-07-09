//
//  HomeViewModel.swift
//  Shop
//
//  Created by josh on 2020/07/02.
//  Copyright © 2020 yhkaplan. All rights reserved.
//

import Foundation
import Combine

final class HomeViewModel {
    private let store: Store<HomeState, HomeAction, HomeEnvironment>

    var statePublisher: Published<HomeState>.Publisher { store.$state }

    init(store: Store<HomeState, HomeAction, HomeEnvironment>) {
        self.store = store
    }

    func viewDidLoad() {
        store.send(.loadSectionData)
    }

    func pullToRefreshGestureDidRecognize() {
        store.send(.loadSectionData)
    }
}
