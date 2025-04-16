//
//  API.swift
//  News
//
//  Created by Yunus Oktay on 20.02.2025.
//

import Foundation
import Alamofire

enum RequestMethod: String {
    case get = "GET"
    case post = "POST"
}

enum Router: URLRequestConvertible {
    case news(query: String, page: Int = 1)

    private var baseURL: String { "https://newsapi.org/" }

    private var path: String {
        switch self {
        case .news:
            return "v2/everything"
        }
    }

    private var method: HTTPMethod {
        switch self {
        case .news:
            return .get
        }
    }

    private var parameters: Parameters {
        switch self {
        case .news(let query, let page):
            return ["q": query,
                    "page": page,
                    "pageSize": 15,
                    "apiKey": API.shared.apiKey ?? ""
            ]
        }
    }

    func asURLRequest() throws -> URLRequest {
        let url = try baseURL.asURL().appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.method = method

        return try URLEncoding.default.encode(request, with: parameters)
    }
}

final class API {
    // MARK: - Singleton
    static let shared = API()

    // MARK: - Properties
    fileprivate let apiKey: String?
    var service: NetworkManagerProtocol

    // MARK: - Init
    init(service: NetworkManagerProtocol = NetworkManager.shared) {
        self.service = service
        self.apiKey = API.loadAPIKey()
    }

    func executeRequestFor<T: Decodable>(
        router: Router) async throws -> T {
        return try await service.execute(urlRequest: router)
    }
}

extension API {
    private static func loadAPIKey() -> String? {
        guard let path = Bundle.main.path(forResource: ".env", ofType: nil) else {
            print(".env file not found")
            return nil
        }

        do {
            let content = try String(contentsOfFile: path)
            let lines = content.split(separator: "\n")

            for line in lines {
                let keyValue = line.split(separator: "=")
                if keyValue.count == 2, keyValue[0].trimmingCharacters(in: .whitespaces) == "API_KEY" {
                    return keyValue[1].trimmingCharacters(in: .whitespaces)
                }
            }
        } catch {
            print("Error reading .env file: \(error)")
        }
        return nil
    }
}
