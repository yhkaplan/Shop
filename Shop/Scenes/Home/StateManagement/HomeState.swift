//
//  HomeState.swift
//  Shop
//
//  Created by josh on 2020/07/09.
//  Copyright © 2020 yhkaplan. All rights reserved.
//

import Foundation

struct HomeState {
    var sections: [HomeViewController.Section: [HomeViewController.Item]] = [:]
    var isRefreshControlAnimating = false
}
