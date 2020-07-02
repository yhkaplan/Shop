//
//  Endpoints.swift
//  Shop
//
//  Created by josh on 2020/07/02.
//  Copyright © 2020 yhkaplan. All rights reserved.
//

import Foundation

struct GETHomeContentEndpoint: Endpoint {
    struct Success: Decodable { let sections: [HomeViewController.Section] }
    let path = "/home_content"
}

struct GETFeaturedProductsEndpoint: Endpoint {
    struct Success: Decodable { let products: [Product] }
    var parameters: [String: String] { ["id": "\(id)"] }
    let path = "/featured_products"
    let id: Int
}

struct GETShortcutsEndpoint: Endpoint {
    struct Success: Decodable { let shortcuts: [Shortcut] }
    var parameters: [String: String] { ["id": "\(id)"] }
    let path = "/shortcuts"
    let id: Int
}

struct GETArticlesEndpoint: Endpoint {
    struct Success: Decodable { let articles: [Article] }
    var parameters: [String: String] { ["id": "\(id)"] }
    let path = "/articles"
    let id: Int
}

struct GETBannersEndpoint: Endpoint {
    struct Success: Decodable { let banners: [Banner] }
    var parameters: [String: String] { ["id": "\(id)"] }
    let path = "/banners"
    let id: Int
}
