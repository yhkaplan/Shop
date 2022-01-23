//
//  CancellationToken.swift
//  Shop
//
//  Created by Joshua Kaplan on 2022/01/23.
//  Copyright © 2022 yhkaplan. All rights reserved.
//

import Foundation

protocol CancellationToken {
    func cancel()
}
extension Task: CancellationToken {}
