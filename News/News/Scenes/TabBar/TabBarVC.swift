//
//  TabBarVC.swift
//  News
//
//  Created by Yunus Oktay on 19.02.2025.
//

import UIKit

final class TabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewControllers()
        configureTabBar()
    }

    private func configureViewControllers() {
        let newsVC = NewsVC()
        let settingsVC = SettingsVC()

        newsVC.tabBarItem = UITabBarItem(
            title: "News",
            image: UIImage(systemName: "newspaper"),
            selectedImage: UIImage(systemName: "newspaper.fill")
            )

        settingsVC.tabBarItem = UITabBarItem(
            title: "Settings",
            image: UIImage(systemName: "gear"),
            selectedImage: UIImage(systemName: "gear.fill")
            )

        setViewControllers([newsVC, settingsVC], animated: true)
    }

    private func configureTabBar() {
        tabBar.tintColor = .systemBlue
        tabBar.backgroundColor = .systemBackground.withAlphaComponent(0.9)
    }

}
