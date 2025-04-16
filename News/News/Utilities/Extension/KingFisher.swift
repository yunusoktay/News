//
//  KingFisher.swift
//  News
//
//  Created by Yunus Oktay on 28.02.2025.
//

import UIKit
import Kingfisher

extension UIImageView {

    func setImage(url: String?) {
        guard let urlStr = url, let url = URL(string: urlStr) else {
            return
        }
        self.kf.setImage(with: url)
    }
}
