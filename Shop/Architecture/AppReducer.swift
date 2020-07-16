//
//  AppReducer.swift
//  Shop
//
//  Created by josh on 2020/07/10.
//  Copyright © 2020 yhkaplan. All rights reserved.
//

import ComposableArchitecture
import Foundation

let appReducer: Reducer<AppState, AppAction, AppEnvironment> = .combine(
    homeReducer.pullback(
        state: \AppState.homeState,
        action: /AppAction.homeViewController,
        environment: { $0.home }
    )
)
