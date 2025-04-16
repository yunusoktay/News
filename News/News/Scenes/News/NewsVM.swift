//
//  NewsVM.swift
//  News
//
//  Created by Yunus Oktay on 20.02.2025.
//

import Foundation

// MARK: - Input Protocol
protocol NewsInputProtocol: AnyObject {
    func fetchInitialNews()
    func searchNews(query: String)
    func selectedArticle(at index: Int)
    func loadMoreArticles()
}

final class NewsVM {
    // MARK: - Properties
    private let newsService: NewsServiceProtocol
    private(set) var articles: [Article] = []
    private var currentPage = 1
    private var isLoading = false
    private var hasMorePages = true
    private var currentQuery = "Apple"

    // MARK: - Delegates
    weak var inputDelegate: NewsInputProtocol?
    weak var outputDelegate: NewsOutputProtocol?

    // MARK: - Init
    init(newsService: NewsServiceProtocol = NewsService()) {
        self.newsService = newsService
        self.inputDelegate = self
    }
}

// MARK: - NewsInputProtocol
extension NewsVM: NewsInputProtocol {

    func fetchInitialNews() {
        currentPage = 1
        articles = []
        currentQuery = "Apple"
        searchNews(query: currentQuery)
    }

    func searchNews(query: String) {
        guard !isLoading else { return }

        if query != currentQuery {
            currentPage = 1
            articles = []
            currentQuery = query
        }

        isLoading = true

        Task {
            do {
                let fetchedArticles = try await newsService.fetchNews(searchString: query, page: currentPage)
                await MainActor.run {
                    self.articles.append(contentsOf: fetchedArticles)
                    self.hasMorePages = !fetchedArticles.isEmpty
                    self.currentPage += 1
                    self.isLoading = false
                    self.outputDelegate?.hideLoading()
                    self.outputDelegate?.updateArticles()
                }
            } catch {
                await MainActor.run {
                    self.isLoading = false
                    self.outputDelegate?.hideLoading()
                    self.outputDelegate?.showError(message: error.localizedDescription)
                }
            }
        }
    }

    func loadMoreArticles() {
        guard !isLoading, hasMorePages else {
            print("Skipping loadMoreArticles: isLoading=\(isLoading), hasMorePages=\(hasMorePages)")
            return
        }

        print("Loading more articles for page \(currentPage)")
        outputDelegate?.showLoading()
        searchNews(query: currentQuery)
    }

    func selectedArticle(at index: Int) {
        guard index >= 0, index < articles.count else {
            print("Invalid index \(index)")
            return
        }

        let selectedArticle = articles[index]
        print("Selected article: \(selectedArticle.title)")
        outputDelegate?.navigateToDetail(article: selectedArticle)
    }
}
