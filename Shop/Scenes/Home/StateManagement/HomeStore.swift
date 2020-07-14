//
//  HomeStore.swift
//  Shop
//
//  Created by josh on 2020/07/14.
//  Copyright © 2020 yhkaplan. All rights reserved.
//

import Foundation
import Combine

final class HomeStore: ObservableObject {
    @Published private(set) var state: HomeState // Also possible to make separate properties for each HomeState property

    init(dispatcher: Dispatcher<HomeAction>, state: HomeState = HomeState()) {
        self.state = state

        dispatcher.register { [weak self] action in
            guard let strongSelf = self else { return }
            switch action {
            case let .didTapCell(section, item):
                let section = strongSelf.state.sections.keys.sorted(by: <)[section]
                let item = strongSelf.state.sections[section]?[item]

                switch item {
                case .product(let product):
                    strongSelf.state.productDetailScreenIsPresented = .presented(product)

                default: fatalError() // TODO:
                }

            case .setSections(let sections):
                strongSelf.state.sections = sections
            default: fatalError()
            }
        }
    }
    
}
