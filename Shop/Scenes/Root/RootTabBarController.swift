//
//  RootTabBarController.swift
//  Shop
//
//  Created by josh on 2020/07/10.
//  Copyright © 2020 yhkaplan. All rights reserved.
//

import UIKit
import ComposableArchitecture

final class RootTabBarController: UITabBarController {
    private let store: Store<AppState, AppAction>

    init(store: Store<AppState, AppAction>) {
        self.store = store
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let homeStore = store.scope(state: { $0.homeState }, action: AppAction.homeViewController)
        let homeVC = HomeViewController(store: homeStore)
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
