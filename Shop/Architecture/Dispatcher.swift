//
//  Dispatcher.swift
//  Shop
//
//  Created by josh on 2020/07/14.
//  Copyright © 2020 yhkaplan. All rights reserved.
//

import Foundation
import Combine

final class Dispatcher<Action> {
    private let action = PassthroughSubject<Action, Never>()
    private var cancellables = Set<AnyCancellable>()

    func register(callback: @escaping (Action) -> ()) {
        action
            .sink(receiveValue: callback)
            .store(in: &cancellables)
    }

    func dispatch(_ action: Action) {
        self.action.send(action)
    }
}
