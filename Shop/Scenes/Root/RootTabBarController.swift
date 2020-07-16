//
//  RootTabBarController.swift
//  Shop
//
//  Created by josh on 2020/07/10.
//  Copyright © 2020 yhkaplan. All rights reserved.
//

import UIKit

final class RootTabBarController: UITabBarController {
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let homeVC = HomeViewController()
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
