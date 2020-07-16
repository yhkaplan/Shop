//
//  RootTabBarController.swift
//  Shop
//
//  Created by josh on 2020/07/10.
//  Copyright © 2020 yhkaplan. All rights reserved.
//

import UIKit

final class RootTabBarController: UITabBarController {
    private let homeStore: HomeStore
    private let homeActionCreator: HomeActionCreator

    init(homeStore: HomeStore, homeActionCreator: HomeActionCreator) {
        self.homeStore = homeStore
        self.homeActionCreator = homeActionCreator
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let homeVC = HomeViewController(store: homeStore, actionCreator: homeActionCreator)

        let navController = UINavigationController(rootViewController: homeVC)
        navController.tabBarItem.title = "Home"
        navController.tabBarItem.image = UIImage(systemName: "house")

        viewControllers = [navController]
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
