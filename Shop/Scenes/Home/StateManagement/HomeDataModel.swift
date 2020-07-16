//
//  HomeDataModel.swift
//  Shop
//
//  Created by josh on 2020/07/15.
//  Copyright © 2020 yhkaplan. All rights reserved.
//

import Foundation
import Combine

final class HomeDataModel: ObservableObject {
    @Published var sections: [HomeViewController.Section: [HomeViewController.Item]] = [:]
    @Published var isLoading = false
}
