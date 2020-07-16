//
//  Combine.swift
//  Shop
//
//  Created by josh on 2020/07/09.
//  Copyright © 2020 yhkaplan. All rights reserved.
//

import Combine
import Foundation

/// Used from: https://github.com/CombineCommunity/CombineExt
public extension Publisher {
    func combineLatest<Others: Collection>(with others: Others)
        -> AnyPublisher<[Output], Failure>
        where Others.Element: Publisher, Others.Element.Output == Output, Others.Element.Failure == Failure {
        let seed = map { [$0] }.eraseToAnyPublisher()

        return others.reduce(seed) { combined, next in
            combined
                .combineLatest(next)
                .map { $0 + [$1] }
                .eraseToAnyPublisher()
        }
    }
}

/// Used from: https://github.com/CombineCommunity/CombineExt
public extension Collection where Element: Publisher {
    func combineLatest() -> AnyPublisher<[Element.Output], Element.Failure> {
        switch count {
        case 0:
            return Empty().eraseToAnyPublisher()
        case 1:
            return self[startIndex]
                .combineLatest(with: [Element]())
        default:
            let first = self[startIndex]
            let others = self[index(after: startIndex)...]

            return first
                .combineLatest(with: others)
        }
    }
}
