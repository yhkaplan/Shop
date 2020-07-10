//
//  HomeReducer.swift
//  Shop
//
//  Created by josh on 2020/07/09.
//  Copyright © 2020 yhkaplan. All rights reserved.
//

import Foundation
import Combine
import ComposableArchitecture

let homeReducer = Reducer<HomeState, HomeAction, HomeEnvironment> { state, action, environment in
    switch action {
    case .loadSectionData:
        state.isSectionLoading = true
        return environment.homeService.homeContentPublisher()
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)  // TODO: use injected q
            .map { HomeAction.loadItemData(sections: $0) }
            .eraseToEffect()

    case .setSections(let sections):
        state.sections = sections
        state.isSectionLoading = false

    case let .didTapCell(section, item):
        let section = state.sections.keys.sorted(by: <)[section]
        let item = state.sections[section]?[item]

        switch item {
        case .product(let product):
            state.productDetailScreenIsPresented = .presented(product)

        default: fatalError() // TODO: 
        }

    case .loadItemData(let sections):
        state.isSectionLoading = true
        return environment.homeService.sectionItemsPublisher(sections: sections)
            .replaceError(with: [:])
            .receive(on: DispatchQueue.main) // TODO: use injected q
            .map { HomeAction.setSections(sections: $0) }
            .eraseToEffect()
    }
    return .none
}
