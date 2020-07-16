//
//  Transitionable.swift
//  Shop
//
//  Created by josh on 2020/07/16.
//  Copyright © 2020 yhkaplan. All rights reserved.
//

import UIKit
import SwiftUI

protocol Transitionable: AnyObject {
    func pushViewController(_ viewController: UIViewController, animated: Bool)
    func pushView<Content: View>(_ view: Content, animated: Bool)
    func present(viewController: UIViewController, animated: Bool, completion: (() -> Void)?)
    func present(viewController: UIViewController, animated: Bool)
    func presentFullScreen(viewController: UIViewController, animated: Bool)

    @discardableResult
    func popToViewControllerType(
        _ ViewControllerType: UIViewController.Type,
        animated: Bool
    ) -> [UIViewController]?
    func popViewController(_ viewController: UIViewController, animated: Bool)
    func popToRootViewController(animated: Bool)
    func dismiss(animated: Bool)
}

// MARK: - UIViewController
extension Transitionable where Self: UIViewController {
    func pushViewController(_ viewController: UIViewController, animated: Bool) {
        navigationController?.pushViewController(viewController, animated: animated)
    }

    func pushView<Content: View>(_ view: Content, animated: Bool) {
        navigationController?.pushViewController(UIHostingController(rootView: view), animated: animated)
    }

    func present(viewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        present(viewController, animated: animated, completion: completion)
    }

    func present(viewController: UIViewController, animated: Bool) {
        present(viewController, animated: animated, completion: nil)
    }

    func presentFullScreen(viewController: UIViewController, animated: Bool) {
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: animated, completion: nil)
    }

    @discardableResult
    func popToViewControllerType(
        _ ViewControllerType: UIViewController.Type,
        animated: Bool
    ) -> [UIViewController]? {
        guard let viewController = navigationController?.viewControllers.first(
            where: { type(of: $0) == ViewControllerType }
        ) else { return nil }

        return navigationController?.popToViewController(viewController, animated: animated)
    }

    func popViewController(_ viewController: UIViewController, animated: Bool) {
        navigationController?.popViewController(animated: animated)
    }

    func popToRootViewController(animated: Bool) {
        navigationController?.popToRootViewController(animated: animated)
    }

    func dismiss(animated: Bool) {
        dismiss(animated: animated)
    }
}
