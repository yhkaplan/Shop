//
//  HomeViewModel.swift
//  Shop
//
//  Created by josh on 2020/07/02.
//  Copyright © 2020 yhkaplan. All rights reserved.
//

import Foundation
import Combine

protocol HomeViewModelOutputs {
    var section: Published<[HomeViewModel.Section : [HomeViewModel.Item]]>.Publisher { get }
}
/*
 - move model code to VM
 - Ref this for interop https://github.com/CombineCommunity/CombineDataSources
 - Use @Published property wrappers?
 - make a DiffableDataSourceAdaptor to abstract away coversions, maybe as generic subclass of DiffableDataSource..
 - look into Redux/ComposibleArch-like pattern
 */
final class HomeViewModel {

    typealias Section = HomeViewController.Section
    typealias Item = HomeViewController.Item

    private let apiClient = APIClient()

    @Published private(set) var sections: [Section: [Item]] = [:] // TODO: remember that dict is unordered make SortedDict
    // @Published is untestable so we could make it private and use the below...
    // var section: Published<[HomeViewModel.Section : [HomeViewModel.Item]]>.Publisher { $_sections }

    private var cancellables = Set<AnyCancellable>()

    init() {}

    func viewDidLoad() {
        downloadAll()
    }

    func pullToRefreshGestureDidRecognize() {
        downloadAll()
    }

    private func downloadAll() {
        apiClient.request(endpoint: GETHomeContentEndpoint())
            .receive(on: DispatchQueue.main) // Runloop.main?
            .replaceError(with: .init(sections: []))
            .sink( // iOS 14.0よりassign(to:Published<Output>.Publisher)が使える
                receiveCompletion: { error in },
                receiveValue: { [weak self] sections in
                    self?.sections = sections.sections.reduce(into: [:]) { dict, section in
                        dict[section] = []
                    }

                    sections.sections.forEach { section in
                        self?.requestSectionItems(for: section)
                    }
                }
        )
            .store(in: &cancellables)
    }

    private func requestSectionItems(for section: Section) {
        switch section.kind {
        case .article:
            apiClient.request(endpoint: GETArticlesEndpoint(id: section.id))
                .receive(on: RunLoop.main) // RunLoop.main?
                .sink(receiveCompletion: {error in}, receiveValue: { [weak self] articles in
                    let items: [Item] = articles.articles.map { .article($0) }
                    self?.sections[section] = items
                })
                .store(in: &cancellables)

        case .featuredProduct:
            apiClient.request(endpoint: GETFeaturedProductsEndpoint(id: section.id))
                .receive(on: RunLoop.main) // RunLoop.main?
                .sink(receiveCompletion: {error in}, receiveValue: { [weak self] products in
                    let items: [Item] = products.products.map { .product($0) }
                    self?.sections[section] = items
                })
                .store(in: &cancellables)
        case .shortcut:
            apiClient.request(endpoint: GETShortcutsEndpoint(id: section.id))
                .receive(on: RunLoop.main) // RunLoop.main?
                .sink(receiveCompletion: {error in}, receiveValue: { [weak self] shortcuts in
                    let items: [Item] = shortcuts.shortcuts.map { .shortcut($0) }
                    self?.sections[section] = items
                })
                .store(in: &cancellables)
        case .banner:
            apiClient.request(endpoint: GETBannersEndpoint(id: section.id))
                .receive(on: RunLoop.main) // RunLoop.main?
                .sink(receiveCompletion: {error in}, receiveValue: { [weak self] banners in
                    let items: [Item] = banners.banners.map { .banner($0) }
                    self?.sections[section] = items
                })
                .store(in: &cancellables)
        }
    }
}
