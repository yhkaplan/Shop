//
//  Product.swift
//  Shop
//
//  Created by josh on 2020/07/01.
//  Copyright © 2020 yhkaplan. All rights reserved.
//

import Foundation

struct Product: Hashable, Decodable {
    let id: String
    let name: String
    let price: String // TODO: Make into Int and decode
    // TODO: imageURL not parsing
    let imageURL: String = "" // This would normally be a URL, but is instead a string to represent an SFSymbol
}
