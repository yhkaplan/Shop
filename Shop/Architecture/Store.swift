//
//  Store.swift
//  Shop
//
//  Created by josh on 2020/07/09.
//  Copyright © 2020 yhkaplan. All rights reserved.
//

import Foundation
import Combine

// Majid-style Redux
// ref: https://github.com/mecid/redux-like-state-container-in-swiftui
final class Store<State, Action, Environment>: ObservableObject {
    @Published private(set) var state: State

    private let environment: Environment
    private let reducer: Reducer<State, Action, Environment>
    private var cancellables: Set<AnyCancellable> = []

    init(
        initialState: State,
        reducer: @escaping Reducer<State, Action, Environment>,
        environment: Environment
    ) {
        self.state = initialState
        self.reducer = reducer
        self.environment = environment
    }

    func send(_ action: Action) {
        guard let effect = reducer(&state, action, environment) else { return }
        effect
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] nextAction in self?.send(nextAction) })
            .store(in: &cancellables)
    }
}
