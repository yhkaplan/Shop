//
//  Store.swift
//  Shop
//
//  Created by Joshua Kaplan on 2022/01/23.
//  Copyright © 2022 yhkaplan. All rights reserved.
//

import Combine
import Foundation

/// Reference:
/// https://swiftwithmajid.com/2019/09/25/redux-like-state-container-in-swiftui-part2/
@MainActor
final class Store<State, Action, Env> {
    typealias LocalReducer = Reducer<State, Action, Env>
    @Published private(set) var state: State
    private let reducer: LocalReducer
    private let env: Env
    var parentCancellable: AnyCancellable?

    init(
        initialState: State,
        reducer: LocalReducer,
        env: Env
    ) {
        self.state = initialState
        self.reducer = reducer
        self.env = env
    }

    @discardableResult
    func send(_ action: Action) -> CancellationToken? {
        guard let effect = reducer(state: &state, action: action, env: env) else { return nil }
        return Task {
            if Task.isCancelled { return }
            guard let nextAction = await effect.value else { return }
            send(nextAction)
        }
    }

    // could add scope method for composition
    // https://github.com/pointfreeco/swift-composable-architecture/blob/main/Sources/ComposableArchitecture/Store.swift#L325-L349
    func scope<LocalState, LocalAction, LocalEnv>(
        state toLocalState: @escaping (State) -> LocalState,
        action fromLocalAction: @escaping (LocalAction) -> Action,
        env toLocalEnv: @escaping (Env) -> LocalEnv
    ) -> Store<LocalState, LocalAction, LocalEnv> {
        let localStore = Store<LocalState, LocalAction, LocalEnv>(
            initialState: toLocalState(state),
            reducer: Store<LocalState, LocalAction, LocalEnv>.LocalReducer.init(reduce: { localState, localAction, _ in
                self.send(fromLocalAction(localAction))
                localState = toLocalState(self.state)
                return .none
            }),
            env: toLocalEnv(env)
        )
        // TODO: check for memory leak issues
        localStore.parentCancellable = self.$state
            .dropFirst()
            .sink { [weak localStore] newValue in
                localStore?.state = toLocalState(newValue)
            }
        return localStore
    }
}
