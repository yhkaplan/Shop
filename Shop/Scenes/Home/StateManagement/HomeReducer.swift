//
//  HomeReducer.swift
//  Shop
//
//  Created by josh on 2020/07/09.
//  Copyright © 2020 yhkaplan. All rights reserved.
//

import Foundation
import Combine

func homeReducer(state: inout HomeState, action: HomeAction, environment: HomeEnvironment) -> AnyPublisher<HomeAction, Never> {
    switch action {
    case .loadSectionData:
        return environment.homeService.homeContentPublisher()
            .replaceError(with: [])
            .receive(on: RunLoop.main)
            .map { HomeAction.loadItemData(sections: $0) }
            .eraseToAnyPublisher()

    case .setSections(let sections):
        state.sections = sections
        return Just(HomeAction.setRefreshControl(isAnimating: false)).eraseToAnyPublisher()

    case let .didTapCell(section, item):
        let section = state.sections.keys.sorted(by: <)[section]
        let item = state.sections[section]?[item]

        switch item {
        case .product(let product):
            state.productDetailScreenIsPresented = .presented(product)

        default: fatalError() // TODO: 
        }

    case .loadItemData(let sections):
        return environment.homeService.sectionItemsPublisher(sections: sections)
            .replaceError(with: [:])
            .receive(on: RunLoop.main)
            .map { HomeAction.setSections(sections: $0) }
            .eraseToAnyPublisher()

    case .setRefreshControl(let isAnimating):
        state.isRefreshControlAnimating = isAnimating
    }
    return Empty().eraseToAnyPublisher()
}
