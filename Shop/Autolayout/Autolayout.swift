//
//  Autolayout.swift
//  Shop
//
//  Created by josh on 2020/06/19.
//  Copyright © 2020 yhkaplan. All rights reserved.
//

import UIKit
// ref: https://www.swiftbysundell.com/posts/building-dsls-in-swift
// TODO: move to Sukar as SPM repo

extension UIView {
    func layout(closure: (LayoutProxy) -> Void) {
        translatesAutoresizingMaskIntoConstraints = false

        let subViewProxy = LayoutProxy(view: self)
        closure(subViewProxy)
    }

    func layout(on parentView: UIView, closure: (LayoutProxy, LayoutProxy) -> Void) {
        translatesAutoresizingMaskIntoConstraints = false

        let subViewProxy = LayoutProxy(view: self)
        let parentViewProxy = LayoutProxy(view: parentView)
        closure(subViewProxy, parentViewProxy)
    }

    func layout(on parentView: UIView, otherView: UIView, closure: (LayoutProxy, LayoutProxy, LayoutProxy) -> Void) {
        translatesAutoresizingMaskIntoConstraints = false

        let subViewProxy = LayoutProxy(view: self)
        let parentViewProxy = LayoutProxy(view: parentView)
        let otherViewProxy = LayoutProxy(view: otherView)
        closure(subViewProxy, parentViewProxy, otherViewProxy)
    }
}

public protocol LayoutDimension {
    func constraint(equalToConstant c: CGFloat) -> NSLayoutConstraint
    func constraint(equalTo anchor: Self, multiplier m: CGFloat, constant c: CGFloat) -> NSLayoutConstraint
}
extension NSLayoutDimension: LayoutDimension {}

public protocol LayoutAnchor {
    func constraint(equalTo anchor: Self, constant: CGFloat) -> NSLayoutConstraint
    func constraint(greaterThanOrEqualTo anchor: Self, constant: CGFloat) -> NSLayoutConstraint
    func constraint(lessThanOrEqualTo anchor: Self, constant: CGFloat) -> NSLayoutConstraint
}

extension NSLayoutAnchor: LayoutAnchor {}

public struct LayoutDimensionProperty<Dimension: LayoutDimension> {
    public let dimension: Dimension
}

public extension LayoutDimensionProperty {

    struct DimensionConstraint<Dimension: LayoutDimension> {
        let layoutDimensionProperty: LayoutDimensionProperty<Dimension>
        let multiplier: CGFloat
        let offset: CGFloat
    }

    func equal(to constant: CGFloat) {
        dimension.constraint(equalToConstant: constant).isActive = true
    }

    func equal(to otherLayoutDimension: LayoutDimensionProperty, multiplier: CGFloat = 1.0, offsetBy constant: CGFloat = 0.0) {
        dimension.constraint(equalTo: otherLayoutDimension.dimension, multiplier: multiplier, constant: constant).isActive = true
    }

}

// MARK: - Operator overloads
public extension LayoutDimensionProperty {

    static func ==(lhs: LayoutDimensionProperty<Dimension>, rhs: CGFloat) {
        lhs.equal(to: rhs)
    }

    static func ==(lhs: LayoutDimensionProperty<Dimension>, rhs: LayoutDimensionProperty<Dimension>) {
        lhs.equal(to: rhs)
    }

    static func ==(lhs: LayoutDimensionProperty<Dimension>, rhs: DimensionConstraint<Dimension>) {
        lhs.equal(to: rhs.layoutDimensionProperty, multiplier: rhs.multiplier, offsetBy: rhs.offset)
    }

    static func +(lhs: LayoutDimensionProperty<Dimension>, rhs: CGFloat) -> DimensionConstraint<Dimension> {
        return DimensionConstraint(layoutDimensionProperty: lhs, multiplier: 1.0, offset: rhs)
    }

    static func -(lhs: LayoutDimensionProperty<Dimension>, rhs: CGFloat) -> DimensionConstraint<Dimension> {
        return DimensionConstraint(layoutDimensionProperty: lhs, multiplier: 1.0, offset: -rhs)
    }

    static func *(lhs: LayoutDimensionProperty<Dimension>, rhs: CGFloat) -> DimensionConstraint<Dimension> {
        return DimensionConstraint(layoutDimensionProperty: lhs, multiplier: rhs, offset: 0.0)
    }
}

public struct LayoutProperty<Anchor: LayoutAnchor> {
    public let anchor: Anchor
}

public extension LayoutProperty {

    func equal(to otherLayoutProperty: LayoutProperty, offsetBy constant: CGFloat = 0.0) {
        anchor.constraint(equalTo: otherLayoutProperty.anchor, constant: constant).isActive = true
    }

    func greaterThanOrEqual(to otherLayoutProperty: LayoutProperty, offsetBy constant: CGFloat = 0.0) {
        anchor.constraint(greaterThanOrEqualTo: otherLayoutProperty.anchor, constant: constant).isActive = true
    }

    func lessThanOrEqual(to otherLayoutProperty: LayoutProperty, offsetBy constant: CGFloat = 0.0) {
        anchor.constraint(lessThanOrEqualTo: otherLayoutProperty.anchor, constant: constant).isActive = true
    }

}

// MARK: - Operator overloads
public extension LayoutProperty {

    static func +(lhs: LayoutProperty<Anchor>, rhs: CGFloat) -> (LayoutProperty<Anchor>, CGFloat) {
        return (lhs, rhs)
    }

    static func -(lhs: LayoutProperty<Anchor>, rhs: CGFloat) -> (LayoutProperty<Anchor>, CGFloat) {
        return (lhs, -rhs)
    }

    static func ==(lhs: LayoutProperty<Anchor>, rhs: (layoutProperty: LayoutProperty<Anchor>, offset: CGFloat)) {
        lhs.equal(to: rhs.layoutProperty, offsetBy: rhs.offset)
    }

    static func ==(lhs: LayoutProperty<Anchor>, rhs: LayoutProperty<Anchor>) {
        lhs.equal(to: rhs)
    }

    static func >=(lhs: LayoutProperty<Anchor>, rhs: (layoutProperty: LayoutProperty<Anchor>, offset: CGFloat)) {
        lhs.greaterThanOrEqual(to: rhs.layoutProperty, offsetBy: rhs.offset)
    }

    static func >=(lhs: LayoutProperty<Anchor>, rhs: LayoutProperty<Anchor>) {
        lhs.greaterThanOrEqual(to: rhs)
    }

    static func <=(lhs: LayoutProperty<Anchor>, rhs: (layoutProperty: LayoutProperty<Anchor>, offset: CGFloat)) {
        lhs.lessThanOrEqual(to: rhs.layoutProperty, offsetBy: rhs.offset)
    }

    static func <=(lhs: LayoutProperty<Anchor>, rhs: LayoutProperty<Anchor>) {
        lhs.lessThanOrEqual(to: rhs)
    }

}
// swiftlint:enable operator_whitespace

public final class LayoutProxy {

    public lazy var leading = LayoutProperty(anchor: view.leadingAnchor)
    public lazy var trailing = LayoutProperty(anchor: view.trailingAnchor)
    public lazy var top = LayoutProperty(anchor: view.topAnchor)
    public lazy var bottom = LayoutProperty(anchor: view.bottomAnchor)

    public lazy var centerY = LayoutProperty(anchor: view.centerYAnchor)
    public lazy var centerX = LayoutProperty(anchor: view.centerXAnchor)

    public lazy var width = LayoutDimensionProperty(dimension: view.widthAnchor)
    public lazy var height = LayoutDimensionProperty(dimension: view.heightAnchor)

    public lazy var layoutMarginsGuide = LayoutGuideProxy(layoutGuide: view.layoutMarginsGuide)
    public lazy var safeAreaLayoutGuide = LayoutGuideProxy(layoutGuide: view.safeAreaLayoutGuide)

    private let view: UIView

    public init(view: UIView) {
        self.view = view
    }

}

public final class LayoutGuideProxy {

    private let layoutGuide: UILayoutGuide

    public lazy var leading = LayoutProperty(anchor: layoutGuide.leadingAnchor)
    public lazy var trailing = LayoutProperty(anchor: layoutGuide.trailingAnchor)
    public lazy var top = LayoutProperty(anchor: layoutGuide.topAnchor)
    public lazy var bottom = LayoutProperty(anchor: layoutGuide.bottomAnchor)

    init(layoutGuide: UILayoutGuide) {
        self.layoutGuide = layoutGuide
    }

}
