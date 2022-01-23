//
//  Reducer.swift
//  Shop
//
//  Created by Joshua Kaplan on 2022/01/23.
//  Copyright © 2022 yhkaplan. All rights reserved.
//

import Foundation

struct Reducer<State, Action, Env>{
    typealias Reduce = (inout State, Action, Env) -> Task<Action?, Never>?
    let reduce: Reduce

    init(reduce: @escaping Reduce) {
        self.reduce = reduce
    }

    func callAsFunction(state: inout State, action: Action, env: Env) -> Task<Action?, Never>? {
        reduce(&state, action, env)
    }

    // could use pullback method like TCA
    // https://github.com/pointfreeco/swift-composable-architecture/blob/main/Sources/ComposableArchitecture/Reducer.swift#L274-L288
    func pullback<GlobalState, GlobalAction, GlobalEnv>(
        state toLocalState: WritableKeyPath<GlobalState, State>,
        toLocalAction: @escaping (GlobalAction) -> Action,
        toGlobalAction: @escaping (Action?) async -> GlobalAction,
        environment toLocalEnv: @escaping (GlobalEnv) -> Env
    ) -> Reducer<GlobalState, GlobalAction, GlobalEnv> {
        .init { globalState, globalAction, globalEnv in
            let newStateTask = self.reduce(
                &globalState[keyPath: toLocalState],
                toLocalAction(globalAction),
                toLocalEnv(globalEnv)
            )
            return Task {
                guard let newState = await newStateTask?.value else { return nil }
                return await toGlobalAction(newState)
            }
        }
    }
}
