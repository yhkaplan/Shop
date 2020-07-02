//
//  Endpoint.swift
//  Shop
//
//  Created by josh on 2020/07/02.
//  Copyright © 2020 yhkaplan. All rights reserved.
//

import Foundation

protocol Endpoint {
    associatedtype Success: Decodable

    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: [String: String] { get }
    var additionalHeaders: [String: String] { get }
    var baseURL: URL { get }
}

extension Endpoint {
    var baseURL: URL { URL(string: "http://localhost:3000/")! }
    var parameters: [String: String] { [:] }
    var additionalHeaders: [String: String] { [:] }
    var method: HTTPMethod { .get }

    func makeRequest() -> URLRequest {
        guard var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true) else { fatalError("Bad URL") }
        urlComponents.path = path
        switch method {
        case .get, .delete:
            if parameters.isEmpty { break }
            urlComponents.queryItems = parameters.map(URLQueryItem.init)
        case .put, .post:
            break
        }

        guard let url = urlComponents.url else { fatalError("Could not make URL") }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        additionalHeaders.forEach { key, value in request.addValue(value, forHTTPHeaderField: key) }
        switch method {
        case .get, .delete:
            break
        case .put, .post:
            // Note: This is not a robust method of encoding parameters for body because it
            // a). does not escape characters and b). does not sort properly.
            // This is only for demo purposes
            request.httpBody = parameters
                .map { key, value in key + "=" + value }
                .joined(separator: "&")
                .data(using: .utf8)
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        }

        return request
    }
}
