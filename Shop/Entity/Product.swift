//
//  Product.swift
//  Shop
//
//  Created by josh on 2020/07/01.
//  Copyright © 2020 yhkaplan. All rights reserved.
//

import Foundation

struct Product: Hashable {
    let id: String // TODO: make ID type-safe https://www.swiftbysundell.com/articles/type-safe-identifiers-in-swift/
    let name: String
    let price: Double
    let imageURL: String // This would normally be a URL, but is instead a string to represent an SFSymbol

    var formattedPrice: String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter.string(from: .init(value: price))
    }
}

extension Product: Decodable {
    enum CodingKeys: String, CodingKey {
        case id, name, price
        case imageURL = "image_url"
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let priceString = try container.decode(String.self, forKey: .price)
        guard let price = Double(priceString) else { throw DecoderError.cannotParse }
        self.price = price

        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        imageURL = try container.decode(String.self, forKey: .imageURL)
    }
}
