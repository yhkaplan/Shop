//
//  HomeService.swift
//  Shop
//
//  Created by josh on 2020/07/09.
//  Copyright © 2020 yhkaplan. All rights reserved.
//

import Combine
import Foundation

final class HomeService {
    typealias Section = (section: HomeViewController.Section, items: [HomeViewController.Item])
    private let apiClient: APIClientType

    init(apiClient: APIClientType = APIClient()) {
        self.apiClient = apiClient
    }

    func homeContent() async throws -> [HomeViewController.Section] {
        let success = try await apiClient.request(endpoint: GETHomeContentEndpoint())
        return success.sections
    }

    func sectionItems(sections: [HomeViewController.Section]) async throws -> [HomeViewController.Section: [HomeViewController.Item]] {
        return try await withThrowingTaskGroup(of: Section.self) { group in
            for section in sections {
                group.addTask {
                    // TODO: strong ref
                    try await self._sectionItems(for: section)
                }
            }

            return try await group.reduce(into: [:]) { result, keyValuePair in
                result[keyValuePair.section] = keyValuePair.items
            }
        }
    }


    private func _sectionItems(for section: HomeViewController.Section) async throws -> Section {
        switch section.kind {
        case .article:
            let success = try await apiClient.request(endpoint: GETArticlesEndpoint(id: section.id))
            let articles = success.articles
            let items: [HomeViewController.Item] = articles.map { .article($0) }
            return (section: section, items: items)

        case .featuredProduct:
            let success = try await apiClient.request(endpoint: GETFeaturedProductsEndpoint(id: section.id))
            let products = success.products
            let items: [HomeViewController.Item] = products.map { .product($0) }
            return (section: section, items: items)

        case .shortcut:
            let success = try await apiClient.request(endpoint: GETShortcutsEndpoint(id: section.id))
            let shortcuts = success.shortcuts
            let items: [HomeViewController.Item] = shortcuts.map { .shortcut($0) }
            return (section: section, items: items)

        case .banner:
            let success = try await apiClient.request(endpoint: GETBannersEndpoint(id: section.id))
            let banners = success.banners
            let items: [HomeViewController.Item] = banners.map { .banner($0) }
            return (section: section, items: items)
        }
    }
}
