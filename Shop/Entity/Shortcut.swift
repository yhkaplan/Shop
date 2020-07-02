//
//  Shortcut.swift
//  Shop
//
//  Created by josh on 2020/07/02.
//  Copyright © 2020 yhkaplan. All rights reserved.
//

import Foundation

struct Shortcut: Hashable {
    let imageURL, id, title: String
}

extension Shortcut: Decodable {
    enum CodingKeys: String, CodingKey {
        case imageURL = "image_url"
        case id, title
    }
}
