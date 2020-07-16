//
//  SceneDelegate.swift
//  Shop
//
//  Created by josh on 2020/06/18.
//  Copyright © 2020 yhkaplan. All rights reserved.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }

        let window = UIWindow(windowScene: windowScene)
        let dispatcher = Dispatcher<HomeAction>()
        let homeStore = HomeStore(dispatcher: dispatcher)
        let homeActionCreator = HomeActionCreator(dispatcher: dispatcher, environment: HomeEnvironment())
        window.rootViewController = RootTabBarController(homeStore: homeStore, homeActionCreator: homeActionCreator)
        self.window = window
        window.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}
}
