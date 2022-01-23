//
//  APIClient.swift
//  Shop
//
//  Created by josh on 2020/07/01.
//  Copyright © 2020 yhkaplan. All rights reserved.
//

import Combine
import Foundation

protocol APIClientType {
    func request<E: Endpoint>(endpoint: E) async throws -> E.Success
}

enum APIError: Error { case unknown, network, server }

final class APIClient: APIClientType {
    typealias DataTaskFunction = (URLRequest, URLSessionTaskDelegate?) async throws -> (Data, URLResponse)
    private let makeDataTask: DataTaskFunction
    private let decoder = JSONDecoder()

    init(makeDataTask: @escaping DataTaskFunction = URLSession.shared.data) {
        self.makeDataTask = makeDataTask
    }

    func request<E: Endpoint>(endpoint: E) async throws -> E.Success {
        let (data, response) = try await makeDataTask(endpoint.makeRequest(), nil)

        guard let response = response as? HTTPURLResponse else { throw APIError.unknown }
        switch response.statusCode {
        case 200 ... 399:
            return try decoder.decode(E.Success.self, from: data)
        case 400 ... 499:
            throw APIError.network
        case 500 ... 599:
            throw APIError.server
        default:
            throw APIError.unknown
        }
    }
}
