//
//  Model.swift
//  News
//
//  Created by Yunus Oktay on 20.02.2025.
//

import Foundation

struct Response: Decodable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}

struct Article: Decodable {
    let source: Source?
    let author, title, description: String?
    let url, urlToImage: String?
    let publishedAt: String?
    let content: String?
}

struct Source: Decodable {
    let id, name: String?
}
