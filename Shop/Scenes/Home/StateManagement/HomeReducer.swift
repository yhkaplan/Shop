//
//  HomeReducer.swift
//  Shop
//
//  Created by josh on 2020/07/09.
//  Copyright © 2020 yhkaplan. All rights reserved.
//

import Foundation

@MainActor
let homeReducer = Reducer<HomeState, HomeAction, HomeEnvironment> { state, action, environment in
    switch action {
    case .loadSectionData:
        state.isSectionLoading = true
        return Task {
            guard let sections = try? await environment.homeService.homeContent() else { return nil }
            return HomeAction.loadItemData(sections: sections)
        }

    case let .setSections(sections):
        state.sections = sections
        state.isSectionLoading = false

    case let .didTapCell(section, item):
        let section = state.sections.keys.sorted(by: <)[section]
        let item = state.sections[section]?[item]

        switch item {
        case let .product(product):
            state.productDetailScreenIsPresented = .presented(product)

        default: fatalError() // TODO:
        }

    case let .loadItemData(sections):
        state.isSectionLoading = true
        return Task {
            guard let sectionData = try? await environment.homeService.sectionItems(sections: sections) else { return nil }
            return HomeAction.setSections(sections: sectionData)
        }
    }
    return .none
}
