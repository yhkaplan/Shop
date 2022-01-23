//
//  ViewStore.swift
//  Shop
//
//  Created by Joshua Kaplan on 2022/01/23.
//  Copyright © 2022 yhkaplan. All rights reserved.
//

import Combine
import Foundation

@dynamicMemberLookup
@MainActor
final class ViewStore<State: Equatable, Action, Env>: ObservableObject {
    @Published private(set) var state: State
    private let store: Store<State, Action, Env>

    subscript<LocalState: Equatable>(
        dynamicMember keyPath: KeyPath<State, LocalState>
    ) -> AnyPublisher<LocalState, Never> {
        $state.map(keyPath).removeDuplicates().eraseToAnyPublisher()
    }

    init(_ store: Store<State, Action, Env>) {
        self.store = store
        self.state = store.state

        store.$state
            .removeDuplicates() // needed to prevent excessive updates
            .assign(to: &$state)
    }

    func send(_ action: Action) {
        store.send(action)
    }
}
