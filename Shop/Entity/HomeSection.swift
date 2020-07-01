//
//  HomeSection.swift
//  Shop
//
//  Created by josh on 2020/07/01.
//  Copyright © 2020 yhkaplan. All rights reserved.
//

import Foundation

struct HomeSection: Decodable {
    let id: Int
    let kind: HomeSectionKind
    let title: String?
    let subtitle: String?
}

enum DecoderError: Error { case cannotParse }

enum HomeSectionKind: String, Hashable {
    case banner, shortcut, article
    case featuredProduct = "featured_product"
}

extension HomeSectionKind: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawString = try container.decode(String.self)
        guard let kind = Self(rawValue: rawString) else { throw DecoderError.cannotParse }
        self = kind
    }
}
