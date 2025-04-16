//
//  DateFormatter.swift
//  News
//
//  Created by Yunus Oktay on 25.02.2025.
//

import Foundation

extension DateFormatter {
    static let articleDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter
    }()

    static let displayDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM, HH:mm"
        formatter.locale = Locale(identifier: "en_US") // 
        return formatter
    }()
}

extension String {
    func formatAsArticleDate() -> String {
        guard let date = DateFormatter.articleDateFormatter.date(from: self) else {
            return self
        }

        return DateFormatter.displayDateFormatter.string(from: date)
    }
}
