//
//  HomeAction.swift
//  Shop
//
//  Created by josh on 2020/07/09.
//  Copyright © 2020 yhkaplan. All rights reserved.
//

import Foundation

enum HomeAction {
    case loadSectionData
    case loadItemData(sections: [HomeViewController.Section])
    case setRefreshControl(isAnimating: Bool)
    case didTapCell(section: Int, item: Int)
    case setSections(sections: [HomeViewController.Section: [HomeViewController.Item]])
}
