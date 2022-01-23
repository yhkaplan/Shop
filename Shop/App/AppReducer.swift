//
//  AppReducer.swift
//  Shop
//
//  Created by josh on 2020/07/10.
//  Copyright © 2020 yhkaplan. All rights reserved.
//

import ComposableArchitecture
import Foundation

// TODO: add combine to reducer
// TODO: handle force unwraps
let appReducer: Reducer<AppState, AppAction, AppEnv> = homeReducer.pullback(
    state: \AppState.homeState,
    toLocalAction: {
        guard case let .homeViewController(action) = $0 else { fatalError() }
        return action
    }, // global -> local
    toGlobalAction: { AppAction.homeViewController($0!) },
    environment: { $0.home}
)

//.combine(
//    homeReducer.pullback(
//        state: \AppState.homeState,
//        action: /AppAction.homeViewController,
//        environment: { $0.home }
//    )
//)
