//
//  HomeEnvironment.swift
//  Shop
//
//  Created by josh on 2020/07/09.
//  Copyright © 2020 yhkaplan. All rights reserved.
//

import Foundation

struct HomeEnvironment {
    init(homeService: HomeService = HomeService()) {
        self.homeService = homeService
    }

    let homeService: HomeService
}
