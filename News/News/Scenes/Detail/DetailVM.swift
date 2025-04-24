//
//  DetailVM.swift
//  News
//
//  Created by Yunus Oktay on 24.04.2025.
//

import Foundation

protocol DetailInputProtocol: AnyObject {
    func viewDidLoad()
    func shareButtonTapped()
}

class DetailVM {

    weak var inputDelegate: DetailInputProtocol?
    weak var outputDelegate: DetailOutputProtocol?

    private var article: Article?

    init(article: Article) {
        self.article = article
        inputDelegate = self
    }
}

extension DetailVM: DetailInputProtocol {
    func viewDidLoad() {
        if let article = article {
            outputDelegate?.updateUI(with: article)
        } else {
            print(NetworkError.requestFailed.localizedDescription)
        }

    }

    func shareButtonTapped() {
        guard let urlString = article?.url, let url = URL(string: urlString) else { return }
        outputDelegate?.shareArticle(title: article?.title ?? "News", url: url)
    }
}
