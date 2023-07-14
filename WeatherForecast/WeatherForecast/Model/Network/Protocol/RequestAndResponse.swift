//
//  RequestAndResponse.swift
//  WeatherForecast
//
//  Created by 이상윤 on 2023/07/14.
//

import Foundation

protocol RequestAndResponse: Request, Response { }

protocol Request {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var query: [URLQueryItem] { get }
}

extension Request {
    private var urlComponent: URL? {
        var components = URLComponents()

        components.scheme = scheme
        components.host = host
        components.path = path
        components.queryItems = query

        return components.url
    }

    func makeURLRequest() throws -> URLRequest {
        guard let url = urlComponent else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        return request
    }
}

protocol Response {
    associatedtype Response
}
