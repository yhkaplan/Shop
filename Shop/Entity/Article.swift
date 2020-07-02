//
//  Article.swift
//  Shop
//
//  Created by josh on 2020/07/02.
//  Copyright © 2020 yhkaplan. All rights reserved.
//

import Foundation

struct Article: Hashable {
    let imageURL, id, title, subtitle: String
}

extension Article: Decodable {
    enum CodingKeys: String, CodingKey {
        case imageURL = "image_url"
        case id, title, subtitle
    }
}
