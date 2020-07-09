//
//  HomeService.swift
//  Shop
//
//  Created by josh on 2020/07/09.
//  Copyright © 2020 yhkaplan. All rights reserved.
//

import Foundation
import Combine

final class HomeService {
    private let apiClient: APIClientType

    init(apiClient: APIClientType = APIClient()) {
        self.apiClient = apiClient
    }

    func homeContentPublisher() -> AnyPublisher<[HomeViewController.Section], Error> {
        apiClient.request(endpoint: GETHomeContentEndpoint())
            .map(\.sections)
            .eraseToAnyPublisher()
    }

    func sectionItemsPublisher(sections: [HomeViewController.Section]) -> AnyPublisher<[HomeViewController.Section: [HomeViewController.Item]], Error> {
        let publishers = sections.map(_sectionItemsPublisher)
        return publishers
            .combineLatest()
            .map { sectionArray in
                sectionArray.reduce(into: [:]) { result, keyValuePair in
                    result[keyValuePair.section] = keyValuePair.items
                }
            }
            .eraseToAnyPublisher()
    }

    private func _sectionItemsPublisher(section: HomeViewController.Section) -> AnyPublisher<(section: HomeViewController.Section, items: [HomeViewController.Item]), Error> {
        switch section.kind {
        case .article:
            return apiClient.request(endpoint: GETArticlesEndpoint(id: section.id))
                .map(\.articles)
                .map { articles in
                    let items: [HomeViewController.Item] = articles.map { .article($0) }
                    return (section: section, items: items)
                }
                .eraseToAnyPublisher()
        case .featuredProduct:
            return apiClient.request(endpoint: GETFeaturedProductsEndpoint(id: section.id))
                .map(\.products)
                .map { products in
                    let items: [HomeViewController.Item] = products.map { .product($0) }
                    return (section: section, items: items)
                }
                .eraseToAnyPublisher()
        case .shortcut:
            return apiClient.request(endpoint: GETShortcutsEndpoint(id: section.id))
                .map(\.shortcuts)
                .map { shortcuts in
                    let items: [HomeViewController.Item] = shortcuts.map { .shortcut($0) }
                    return (section: section, items: items)
                }
                .eraseToAnyPublisher()
        case .banner:
            return apiClient.request(endpoint: GETBannersEndpoint(id: section.id))
                .map(\.banners)
                .map { banners in
                    let items: [HomeViewController.Item] = banners.map { .banner($0) }
                    return (section: section, items: items)
                }
                .eraseToAnyPublisher()
        }
    }
}
