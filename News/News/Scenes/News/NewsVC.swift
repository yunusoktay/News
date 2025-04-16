//
//  NewsVC.swift
//  News
//
//  Created by Yunus Oktay on 19.02.2025.
//

import UIKit
import SnapKit

// MARK: - Output Protocol
protocol NewsOutputProtocol: AnyObject {
    func updateArticles()
    func showError(message: String)
    func navigateToDetail(article: Article)
    func showLoading()
    func hideLoading()
}

final class NewsVC: UIViewController {

    // MARK: - Properties
    private let viewModel: NewsVM = .init()

    // MARK: - UI Components
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "News"
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.textColor = .label
        return label
    }()

    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.searchBarStyle = .minimal
        searchBar.delegate = self
        return searchBar
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(NewsCell.self, forCellReuseIdentifier: NewsCell.identifier)
        return tableView
    }()

    private lazy var loadingFooterView: LoadingFooterView = {
        let footerView = LoadingFooterView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        return footerView
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLoadingFooterView()
        viewModel.outputDelegate = self
        viewModel.inputDelegate?.fetchInitialNews()
    }

    deinit {
        print("NewsVC deallocated from memory")
    }

    // MARK: - Setup
    private func setupUI() {
        configureView()
        configureTitleLabel()
        configureSearchBar()
        configureTableView()
    }

    private func setupLoadingFooterView() {
        tableView.tableFooterView = loadingFooterView
        tableView.tableFooterView?.isHidden = true
    }
}

// MARK: - UI Configuration
private extension NewsVC {
    private func configureView() {
        view.backgroundColor = .systemBackground
    }

    private func configureTitleLabel() {
        view.addSubview(titleLabel)

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.equalToSuperview().offset(16)
        }
    }

    private func configureSearchBar() {
        view.addSubview(searchBar)

        searchBar.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
        }

        let tabBarHeight = tabBarController?.tabBar.frame.height ?? 0
        tableView.contentInset.bottom = tabBarHeight

        tabBarController?.tabBar.isTranslucent = true
    }

    private func configureTableView() {
        view.addSubview(tableView)

        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

    func showAlert(message: String) {
        let alert = UIAlertController(title: "Hata", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        present(alert, animated: true)
    }

}

// MARK: - UISearchBarDelegate
extension NewsVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("Searching for: \(searchText)")
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        searchBar.resignFirstResponder()
        viewModel.inputDelegate?.searchNews(query: searchText)
    }
}

// MARK: - NewsOutputProtocol
extension NewsVC: NewsOutputProtocol {
    func updateArticles() {
        tableView.reloadData()
    }

    func showError(message: String) {
        showAlert(message: message)
    }

    func navigateToDetail(article: Article) {
        let detailVC = DetailVC(article: article)
        navigationController?.pushViewController(detailVC, animated: true)
    }

    func showLoading() {
            loadingFooterView.startAnimating()
            tableView.tableFooterView?.isHidden = false
        }

    func hideLoading() {
        loadingFooterView.stopAnimating()
        tableView.tableFooterView?.isHidden = true
    }
}

// MARK: - UITableView Delegate & DataSource
extension NewsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.articles.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let imageSize = UIScreen.main.bounds.height * 0.18
        return imageSize + 16
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsCell.identifier, for: indexPath) as? NewsCell else {
            return UITableViewCell()
        }

        let article = viewModel.articles[indexPath.row]
        cell.configure(
            with: article, title: article.title ?? "",
            description: article.description ?? "",
            category: article.source?.name ?? "",
            time: (article.publishedAt ?? "").formatAsArticleDate()
        )

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.inputDelegate?.selectedArticle(at: indexPath.row)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let screenHeight = scrollView.frame.size.height

        if position > contentHeight - screenHeight - 100 {
            viewModel.inputDelegate?.loadMoreArticles()
        }
    }
}
