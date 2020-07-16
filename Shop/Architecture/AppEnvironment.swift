//
//  AppEnvironment.swift
//  Shop
//
//  Created by josh on 2020/07/10.
//  Copyright © 2020 yhkaplan. All rights reserved.
//

import Combine
import ComposableArchitecture
import Foundation

struct AppEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var home: HomeEnvironment
}
