//
//  HomeInteractor.swift
//  Shop
//
//  Created by josh on 2020/07/15.
//  Copyright © 2020 yhkaplan. All rights reserved.
//

import Foundation
import Combine

final class HomeInteractor {
    let model: HomeDataModel
    private let homeProvider: HomeProvider
    private var cancellables = Set<AnyCancellable>()

    init(model: HomeDataModel, homeProvider: HomeProvider) {
        self.model = model
        self.homeProvider = homeProvider
    }

    func loadData() {
        homeProvider.homeContentPublisher()
            .replaceError(with: [])
            .sink(receiveValue: { [weak self] sections in
                guard let strongSelf = self else { return }
                strongSelf.homeProvider.sectionItemsPublisher(sections: sections)
                    .replaceError(with: [:])
                    .receive(on: DispatchQueue.main)
                    .sink(receiveValue: { sections in
                        strongSelf.model.sections = sections
                        strongSelf.model.isLoading = false
                    }).store(in: &strongSelf.cancellables)
            }).store(in: &cancellables)
    }
}
