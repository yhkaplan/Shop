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
    func request<E: Endpoint>(endpoint: E) -> AnyPublisher<E.Success, Error>
}

enum APIError: Error { case unknown, network, server }

final class APIClient: APIClientType {
    private let dataTaskPublisher: (URLRequest) -> URLSession.DataTaskPublisher

    init(dataTaskPublisher: @escaping (URLRequest) -> URLSession.DataTaskPublisher = URLSession.shared.dataTaskPublisher) {
        self.dataTaskPublisher = dataTaskPublisher
    }

    func request<E: Endpoint>(endpoint: E) -> AnyPublisher<E.Success, Error> {
        dataTaskPublisher(endpoint.makeRequest())
            .tryMap { data, response in
                guard let response = response as? HTTPURLResponse else { throw APIError.unknown }
                switch response.statusCode {
                case 200 ... 399: return data
                case 400 ... 499: throw APIError.network
                case 500 ... 599: throw APIError.server
                default: throw APIError.unknown
                }
            }
            .decode(type: E.Success.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
