//
//  Service.swift
//  News
//
//  Created by Yunus Oktay on 20.02.2025.
//

import Foundation

protocol NewsServiceProtocol {
    func fetchNews(searchString: String, page: Int) async throws -> [Article]
}

final class NewsService {
    private let api: API

    init(api: API = API.shared) {
        self.api = api
    }
}

// MARK: - NetworkManagerProtocol

extension NewsService: NewsServiceProtocol {
    func fetchNews(searchString: String, page: Int = 1) async throws -> [Article] {
        let result: Response = try await api.executeRequestFor(router: .news(query: searchString, page: page))
        return result.articles
    }
}
